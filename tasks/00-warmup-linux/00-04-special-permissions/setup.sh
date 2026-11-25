#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-04"
run_privileged rm -rf /srv/ex188-00-04
getent group devshare >/dev/null 2>&1 || run_privileged groupadd -g 2460 devshare
run_privileged usermod -aG devshare "$(student_user)" 2>/dev/null || true
