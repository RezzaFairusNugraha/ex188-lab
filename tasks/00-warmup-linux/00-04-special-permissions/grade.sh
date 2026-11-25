#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-04"

check_cmd 3 "/srv/ex188-00-04/collab owned by root:devshare with setgid mode 2775" \
    "collab directory missing, wrong owner/group, or mode is not 2775" \
    bash -c '[[ "$(stat -c "%U:%G:%a" /srv/ex188-00-04/collab 2>/dev/null)" == "root:devshare:2775" ]]'

check_cmd 3 "/srv/ex188-00-04/dropoff owned by root:root with sticky mode 1777" \
    "dropoff directory missing, wrong owner/group, or mode is not 1777" \
    bash -c '[[ "$(stat -c "%U:%G:%a" /srv/ex188-00-04/dropoff 2>/dev/null)" == "root:root:1777" ]]'

check_cmd 4 "/srv/ex188-00-04/collab/ready.txt exists and inherited group 'devshare'" \
    "ready.txt missing or group owner is not devshare" \
    bash -c '[[ -f /srv/ex188-00-04/collab/ready.txt ]] && [[ "$(stat -c "%G" /srv/ex188-00-04/collab/ready.txt)" == "devshare" ]]'

grade_finish
