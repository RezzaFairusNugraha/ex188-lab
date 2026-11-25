#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-02"
WORK="$(student_home)/workspace/01-02"

assert_file_contains 3 "${WORK}/digest.txt" "^sha256:[0-9a-f]{64}$" "Valid sha256 digest saved in digest.txt"
DIG="$(head -n1 "${WORK}/digest.txt" 2>/dev/null | tr -d '[:space:]')"
assert_file_contains 3 "${WORK}/Containerfile" "^FROM registry\.lab\.local:5000/base/ubi-pinned@${DIG}$" "Containerfile FROM pins exact @sha256 digest without tag"
assert_image_exists 2 "localhost/pinned-app:1.0"
check_cmd 2 "Image contains /etc/release-channel = pinned-build" \
    "/etc/release-channel missing or wrong content inside localhost/pinned-app:1.0" \
    bash -c "podman run --rm localhost/pinned-app:1.0 cat /etc/release-channel | grep -qx 'pinned-build'"

grade_finish
