#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
WORK="$(student_home)/workspace/00-08"
if [[ -f "${WORK}/pids.txt" ]]; then
    xargs -r kill < "${WORK}/pids.txt" 2>/dev/null || true
fi
rm -rf "${WORK}"
