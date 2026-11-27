#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-03"
WORK="$(student_home)/workspace/01-03"
IMG="localhost/minimal-archiver:1.0"

assert_file_contains 3 "${WORK}/Containerfile" "^FROM registry\.access\.redhat\.com/ubi10/ubi-minimal" "Uses ubi10/ubi-minimal base"
assert_file_contains 3 "${WORK}/Containerfile" "microdnf.*clean all" "Cleans microdnf metadata in Containerfile"
if [[ -f "${WORK}/Containerfile" ]] && [[ "$(grep -Ec '^[[:space:]]*RUN[[:space:]]' "${WORK}/Containerfile")" -eq 1 ]]; then
    pass_check 3 "Uses a single consolidated RUN instruction"
else
    fail_check 3 "Single RUN instruction check" "expected exactly 1 RUN instruction in Containerfile"
fi
assert_image_exists 2 "${IMG}"
assert_image_user 2 "${IMG}" "1001"
check_cmd 2 "Running localhost/minimal-archiver:1.0 outputs GNU tar version" \
    "container failed to execute /usr/bin/tar --version" \
    bash -c "podman run --rm '${IMG}' | grep -qi 'tar'"

grade_finish
