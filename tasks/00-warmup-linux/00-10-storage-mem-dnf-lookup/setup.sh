#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-10"
WORK="$(student_home)/workspace/00-10"
rm -rf "${WORK}"
mkdir -p "${WORK}"
chown -R "$(student_user):$(student_user)" "${WORK}" 2>/dev/null || true
