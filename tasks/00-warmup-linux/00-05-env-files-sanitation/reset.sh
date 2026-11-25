#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
rm -f "/home/$(student_user)/.bashrc.d/ex188-profile.sh"
rm -rf "/home/$(student_user)/workspace/00-05"
