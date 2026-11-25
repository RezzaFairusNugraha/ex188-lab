#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-13"
IMG="localhost/worker-exec:1.0"

assert_image_exists 2 "${IMG}"
check_cmd 3 "Image Config.Cmd is exec form without /bin/sh -c" \
    "Config.Cmd still invokes /bin/sh -c (shell form)" \
    bash -c "! podman image inspect --format '{{json .Config.Cmd}}' '${IMG}' | grep -q '/bin/sh'"
assert_container_running 2 "worker-clean"
check_cmd 3 "PID 1 inside worker-clean is python3 (not sh)" \
    "PID 1 inside worker-clean is not python3" \
    bash -c "podman exec worker-clean cat /proc/1/comm | grep -q '^python'"

grade_finish
