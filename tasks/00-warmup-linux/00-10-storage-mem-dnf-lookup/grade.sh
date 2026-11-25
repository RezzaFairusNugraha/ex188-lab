#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-10"
OUT="$(student_home)/workspace/00-10/host-audit.env"
EXP_FS="$(df -PT / | awk 'NR==2 {print $2}')"
EXP_MEM="$(free -m | awk '/^Mem:/ {print $2}')"

assert_file_exists 1 "${OUT}" "Report ${OUT} exists"
assert_file_contains 3 "${OUT}" "^ROOT_FSTYPE=${EXP_FS}$" "ROOT_FSTYPE matches active / filesystem (${EXP_FS})"
assert_file_contains 3 "${OUT}" "^TOTAL_MEM_MIB=${EXP_MEM}$" "TOTAL_MEM_MIB matches free -m (${EXP_MEM})"
assert_file_contains 3 "${OUT}" "^SEMANAGE_RPM=policycoreutils-python-utils$" "SEMANAGE_RPM identifies policycoreutils-python-utils"

grade_finish
