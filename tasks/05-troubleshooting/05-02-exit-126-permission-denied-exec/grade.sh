#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-02"

assert_container_running 5 "worker-0502"
check_cmd 5 "worker-0502 logs confirm worker-py started cleanly" \
    "podman logs worker-0502 missing 'worker-py started'" \
    bash -c "podman logs worker-0502 2>&1 | grep -q 'worker-py started'"

grade_finish
