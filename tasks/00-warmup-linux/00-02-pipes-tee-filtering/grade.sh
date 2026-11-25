#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-02"
WORK="/home/$(student_user)/workspace/00-02"
ALL_F="${WORK}/errors-all.log"
TAIL_F="${WORK}/errors-tail.log"

assert_file_exists 1 "${ALL_F}" "Filtered log ${ALL_F} exists"
if [[ -f "${ALL_F}" ]] && [[ "$(wc -l < "${ALL_F}")" -eq 5 ]] && ! grep -q '/healthz' "${ALL_F}"; then
    pass_check 2 "errors-all.log contains exactly the 5 non-healthz ERROR/CRITICAL lines"
else
    fail_check 2 "errors-all.log content check" "expected 5 matching lines and zero /healthz entries"
fi

if [[ -f "${TAIL_F}" ]] && [[ "$(wc -l < "${TAIL_F}")" -eq 3 ]] && grep -q 'disk-readonly-04' "${TAIL_F}" && grep -q 'bad-gateway-02' "${TAIL_F}"; then
    pass_check 2 "errors-tail.log contains the exact last 3 filtered error lines"
else
    fail_check 2 "errors-tail.log content check" "expected 3 trailing lines ending with disk-readonly-04"
fi

grade_finish
