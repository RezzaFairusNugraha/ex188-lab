#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-05"
WORK="$(student_home)/workspace/01-05"
IMG="localhost/chown-demo:1.0"

assert_file_not_contains 3 "${WORK}/Containerfile" "^RUN .*(chown|chmod)" "No separate RUN chown/chmod layer used"
assert_image_exists 2 "${IMG}"
assert_image_user 2 "${IMG}" "1001"
check_cmd 4 "/opt/app/launcher.sh has uid:gid:mode 1001:1001:755" \
    "launcher.sh ownership or mode inside image is not 1001:1001:755" \
    bash -c "[[ \"\$(podman run --rm --entrypoint stat '${IMG}' -c '%u:%g:%a' /opt/app/launcher.sh)\" == '1001:1001:755' ]]"
check_cmd 4 "/opt/app/settings.ini has uid:gid:mode 1001:1001:640 and container runs cleanly" \
    "settings.ini ownership/mode mismatch or container execution failed" \
    bash -c "[[ \"\$(podman run --rm --entrypoint stat '${IMG}' -c '%u:%g:%a' /opt/app/settings.ini)\" == '1001:1001:640' ]] && podman run --rm '${IMG}' | grep -qx 'mode=verified'"

grade_finish
