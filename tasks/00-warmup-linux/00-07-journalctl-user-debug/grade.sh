#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-07"
DIAG_CODE="${DIAG_CODE:-ERR_SPOOL_409}"
WORK="$(student_home)/workspace/00-07"

assert_file_contains 2 "${WORK}/diag-token.txt" "^${DIAG_CODE}$" "Diagnostic token ${DIAG_CODE} recorded in diag-token.txt"
assert_dir_exists 1 "${WORK}/incoming-jobs" "Missing directory ${WORK}/incoming-jobs created"
check_cmd 2 "User service ex188-spoolcheck.service is active" \
    "ex188-spoolcheck.service is not active" \
    systemctl --user is-active --quiet ex188-spoolcheck.service

grade_finish
