#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-15"
HOST_PORT="${HOST_PORT:-9190}"
WORK="$(student_home)/workspace/01-15"
IMG="localhost/metrics-go:1.0"

assert_file_contains 3 "${WORK}/Containerfile" "COPY .*--from=" "Multi-stage COPY --from= used in Containerfile"
assert_image_exists 3 "${IMG}"
assert_image_user 3 "${IMG}" "1001"
check_cmd 4 "Final image omits Go compiler and source code" \
    "go compiler or main.go leaked into final runtime stage" \
    bash -c "! podman run --rm --entrypoint sh '${IMG}' -c 'command -v go || find / -name main.go 2>/dev/null | grep -q main.go'"
assert_container_running 3 "metrics-agent"
assert_http_ok 4 "http://127.0.0.1:${HOST_PORT}/metrics" 'ex188_up\{service="edge-telemetry"\} 1'

grade_finish
