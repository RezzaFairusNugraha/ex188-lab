#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-06"
SP="$(student_home)/workspace/04-06/spool"

assert_container_running 3 "job-consumer"
assert_container_running 3 "job-producer"
CTX="$(stat -c '%C' "${SP}/inbox" 2>/dev/null || true)"
if [[ "${CTX}" == *":container_file_t:s0" ]]; then
    pass_check 4 "spool/inbox carries shared container_file_t:s0 label (:z)"
else
    fail_check 4 "SELinux shared :z check" "got '${CTX}', expected ':container_file_t:s0' without private MCS categories"
fi
assert_file_contains 5 "${SP}/outbox/batch1.done" "PROCESSED: ORDER-77" "job-consumer processed batch1.job -> batch1.done"

grade_finish
