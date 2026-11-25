#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-12"
run_privileged setsebool -P container_manage_cgroup off >/dev/null 2>&1 || true
WORK="$(student_home)/workspace/00-12"
rm -rf "${WORK}"
mkdir -p "${WORK}/shared-dir" "${WORK}/private-dir"
chown -R "$(student_user):$(student_user)" "${WORK}" 2>/dev/null || true
