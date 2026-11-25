#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-08"
WORK="$(student_home)/workspace/03-08"

check_cmd 5 "recent-timestamped.log has 5 lines with timestamps ending at ALERT-C" \
    "recent-timestamped.log does not have 5 timestamped lines" \
    bash -c "[[ -f '${WORK}/recent-timestamped.log' ]] && [[ \"\$(wc -l < '${WORK}/recent-timestamped.log')\" -eq 5 ]] && grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}T.*ALERT-C$' '${WORK}/recent-timestamped.log'"

check_cmd 5 "stderr-only.log contains all 3 ALERT lines and zero LINE- entries" \
    "stderr-only.log missing ALERT lines or contains stdout LINE- entries" \
    bash -c "[[ -f '${WORK}/stderr-only.log' ]] && [[ \"\$(wc -l < '${WORK}/stderr-only.log')\" -eq 3 ]] && ! grep -q 'LINE-' '${WORK}/stderr-only.log' && grep -q 'ALERT-A' '${WORK}/stderr-only.log'"

grade_finish
