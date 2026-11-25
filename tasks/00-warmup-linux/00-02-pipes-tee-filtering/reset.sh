#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
rm -rf /var/tmp/ex188-00-02 "/home/$(student_user)/workspace/00-02"
