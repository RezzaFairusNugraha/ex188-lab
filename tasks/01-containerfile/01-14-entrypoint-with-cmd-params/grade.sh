#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-14"
IMG="localhost/worker-appliance:1.0"

assert_image_exists 3 "${IMG}"
check_cmd 4 "Image defines exec ENTRYPOINT and default CMD" \
    "Config.Entrypoint or Config.Cmd does not match specification" \
    bash -c "podman image inspect --format '{{json .Config.Entrypoint}}' '${IMG}' | grep -q '/opt/worker/worker.py' && podman image inspect --format '{{json .Config.Cmd}}' '${IMG}' | grep -q 'DEFAULT'"
assert_container_running 2 "worker-default"
assert_container_running 2 "worker-fast"
check_cmd 4 "worker-fast processes a test job with prefix 'FAST:'" \
    "worker-fast did not apply overridden --prefix FAST argument" \
    bash -c "podman exec worker-fast sh -c 'echo hello > /var/spool/worker/inbox/t1.job' && sleep 2 && podman exec worker-fast cat /var/spool/worker/outbox/t1.done | grep -qx 'FAST: HELLO'"

grade_finish
