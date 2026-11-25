#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-24"
WORK="$(student_home)/workspace/01-24"
IMG="localhost/webapp-remediated:2.0"

if [[ -f "${WORK}/Containerfile" ]] && [[ "$(grep -c '^RUN ' "${WORK}/Containerfile")" -eq 1 ]]; then
    pass_check 4 "Containerfile uses a single consolidated RUN instruction"
else
    fail_check 4 "Single RUN check" "Containerfile does not have exactly 1 RUN instruction"
fi
assert_image_exists 2 "${IMG}"
assert_image_user 3 "${IMG}" "1001"
check_cmd 4 "No APP_SECRET baked into image Env or History, and CMD is exec form" \
    "APP_SECRET found in image metadata or CMD is still shell form" \
    bash -c "! podman image inspect '${IMG}' | grep -q 'HardcodedBadSecret' && ! podman image inspect --format '{{json .Config.Cmd}}' '${IMG}' | grep -q '/bin/sh'"
assert_container_running 3 "webapp-clean"
assert_http_ok 4 "http://127.0.0.1:8124/" '"secret_source": *"file"'

grade_finish
