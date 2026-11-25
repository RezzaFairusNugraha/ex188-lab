#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-08"
WORK="$(student_home)/workspace/02-08"

assert_file_contains 3 "${WORK}/tags-output.txt" "2\.0-rc1" "tags-output.txt lists remote tags including 2.0-rc1"
assert_file_contains 4 "${WORK}/manifest.json" '"schemaVersion": *2' "manifest.json contains valid v2 manifest JSON"
check_cmd 3 "Image was NOT pulled into local Podman storage" \
    "found catalog/billing-api in local podman images (task required remote-only inspection)" \
    bash -c "! podman images --format '{{.Repository}}' | grep -q 'catalog/billing-api'"

grade_finish
