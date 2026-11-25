#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-15"
TAR="$(student_home)/workspace/02-15/stack-bundle.tar"

assert_file_exists 3 "${TAR}" "Bundle ${TAR} exists"
check_cmd 6 "manifest.json inside stack-bundle.tar references both bundle-web:1.0 and bundle-api:1.0" \
    "stack-bundle.tar does not contain both repository tags in manifest.json (did you pass -m?)" \
    bash -c "tar -xOf '${TAR}' manifest.json | grep -q 'bundle-web:1.0' && tar -xOf '${TAR}' manifest.json | grep -q 'bundle-api:1.0'"
assert_image_exists 3 "localhost/bundle-web:1.0"
assert_image_exists 3 "localhost/bundle-api:1.0"

grade_finish
