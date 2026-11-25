#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-01"
TARGET_PORT="${TARGET_PORT:-8080}"
FILE="/home/$(student_user)/workspace/00-01/service-draft.yaml"

assert_file_exists 1 "${FILE}" "Manifest ${FILE} exists"
if [[ -f "${FILE}" ]] && [[ "$(grep -c 'registry.access.redhat.com/ubi10' "${FILE}")" -eq 2 ]] && ! grep -q 'docker.io/legacycorp' "${FILE}"; then
    pass_check 1 "All legacy registry prefixes replaced with registry.access.redhat.com/ubi10"
else
    fail_check 1 "All legacy registry prefixes replaced" "expected 2 occurrences of registry.access.redhat.com/ubi10 and 0 of docker.io/legacycorp"
fi
assert_file_contains 1 "${FILE}" "containerPort: ${TARGET_PORT}" "Container ports updated to ${TARGET_PORT}"
assert_file_not_contains 1 "${FILE}" "DEPRECATED_SETTING" "All DEPRECATED_SETTING lines removed"
assert_file_contains 1 "${FILE}" "^  restartPolicy: Always$" "restartPolicy: Always added under spec"

grade_finish
