#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-24"
SUSER="$(student_user)"

assert_service_persistent 5 "user" "journal-web.service"
assert_user_linger 2 "${SUSER}"
assert_selinux_type 3 "/srv/student-journal" "container_file_t" "/srv/student-journal labeled container_file_t"
assert_http_ok 4 "http://127.0.0.1:8324/healthz" '"status": *"ok"'
check_cmd 6 "/srv/student-journal/entries.log contains survived-restart-test and is owned on host by ${SUSER}" \
    "entries.log missing expected note or not owned by ${SUSER}" \
    bash -c "grep -q 'survived-restart-test' /srv/student-journal/entries.log && [[ \"\$(stat -c '%U' /srv/student-journal/entries.log)\" == '${SUSER}' ]]"

grade_finish
