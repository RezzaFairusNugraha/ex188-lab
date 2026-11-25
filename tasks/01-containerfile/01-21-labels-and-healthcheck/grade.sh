#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-21"
IMG="localhost/worker-labeled:1.0"

assert_image_exists 2 "${IMG}"
check_cmd 3 "All three required LABEL keys exist on image" \
    "one or more required LABEL keys missing on localhost/worker-labeled:1.0" \
    bash -c "lbl=\$(podman image inspect --format '{{json .Config.Labels}}' '${IMG}'); grep -q 'spool-worker' <<< \"\${lbl}\" && grep -q 'Acme Platform' <<< \"\${lbl}\" && grep -q 'cloud-ops' <<< \"\${lbl}\""
assert_container_running 2 "worker-hc"
podman healthcheck run worker-hc >/dev/null 2>&1 || true
assert_container_healthy 3 "worker-hc"

grade_finish
