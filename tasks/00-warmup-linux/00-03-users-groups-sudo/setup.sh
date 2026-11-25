#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-03"
seed_var "00-03" TARGET_UID "2401" "2401" "2411" "2421" "2431"

run_privileged rm -f /etc/sudoers.d/ex188-svcrunner
id svcrunner >/dev/null 2>&1 && run_privileged userdel -r svcrunner 2>/dev/null || true
getent group containerops >/dev/null 2>&1 && run_privileged groupdel containerops 2>/dev/null || true
