#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-07"
WORK="$(student_home)/workspace/01-07"
IMG="localhost/lean-python:1.0"

if [[ -f "${WORK}/Containerfile" ]] && [[ "$(grep -Ec '^[[:space:]]*RUN[[:space:]]' "${WORK}/Containerfile")" -eq 1 ]]; then
    pass_check 4 "Containerfile consolidates all build steps into 1 RUN instruction"
else
    fail_check 4 "Single RUN instruction check" "Containerfile still has multiple RUN instructions"
fi
assert_image_exists 3 "${IMG}"
check_cmd 4 "/etc/app-checksum exists and /tmp/stage.bin is absent" \
    "missing /etc/app-checksum or /tmp/stage.bin still exists" \
    bash -c "podman run --rm '${IMG}' test -s /etc/app-checksum && podman run --rm '${IMG}' test ! -e /tmp/stage.bin"

OLD_SZ="$(podman image inspect --format '{{.Size}}' localhost/bloated-python:legacy 2>/dev/null || echo 0)"
NEW_SZ="$(podman image inspect --format '{{.Size}}' "${IMG}" 2>/dev/null || echo 9999999999)"
if [[ "${OLD_SZ}" -gt 0 ]] && (( OLD_SZ - NEW_SZ >= 45000000 )); then
    pass_check 4 "Image size reduced by >= 45 MB compared to bloated multi-RUN build"
else
    fail_check 4 "Image size reduction check" "bloated=${OLD_SZ} bytes, lean=${NEW_SZ} bytes (expected >= 45 MB savings)"
fi

grade_finish
