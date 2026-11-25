#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-04"
WORK="$(student_home)/workspace/01-04"
IMG="localhost/portal-static:1.0"

assert_file_not_contains 2 "${WORK}/Containerfile" "^RUN .*tar " "Containerfile does not use RUN tar"
assert_image_exists 2 "${IMG}"
check_cmd 3 "site-assets.tar.gz was auto-extracted into /usr/share/nginx/html/index.html" \
    "/usr/share/nginx/html/index.html missing or does not match archive content" \
    bash -c "podman run --rm '${IMG}' cat /usr/share/nginx/html/index.html | grep -q 'Extracted by ADD'"
check_cmd 3 "release-backup.tar.gz copied intact as literal archive in /usr/share/nginx/html/downloads/" \
    "release-backup.tar.gz missing or was unpacked instead of copied literally" \
    bash -c "podman run --rm '${IMG}' test -f /usr/share/nginx/html/downloads/release-backup.tar.gz"

grade_finish
