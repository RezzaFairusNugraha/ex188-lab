#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-10"
OUT="$(student_home)/workspace/03-10/events.log"

assert_file_exists 3 "${OUT}" "events.log exists"
assert_file_contains 4 "${OUT}" "^start event-probe$" "Captured formatted 'start event-probe' line"
assert_file_contains 4 "${OUT}" "^die event-probe$" "Captured formatted 'die event-probe' line"
check_cmd 4 "No extraneous event statuses (create/init/attach/remove) in events.log" \
    "events.log contains unfiltered event statuses other than start/die" \
    bash -c "! grep -Ev '^(start|die) event-probe$' '${OUT}' | grep -q ."

grade_finish
