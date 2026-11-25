#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-06"
SUSER="$(student_user)"
SHOME="$(student_home)"
UNIT_PATH="${SHOME}/.config/systemd/user/ex188-pulse.service"

assert_file_exists 2 "${UNIT_PATH}" "Unit file ${UNIT_PATH} exists"
assert_service_persistent 4 "user" "ex188-pulse.service"
assert_user_linger 2 "${SUSER}"
assert_file_contains 2 "${SHOME}/workspace/00-06/pulse.log" "pulse-alive" "Service wrote heartbeat entries to pulse.log"

grade_finish
