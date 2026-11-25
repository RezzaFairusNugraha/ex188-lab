#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-08"
seed_var "01-08" APP_UID "1001" "1001" "1002" "2001"

WORK="$(student_home)/workspace/01-08"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rmi -f localhost/webapp-flask:1.0 >/dev/null 2>&1 || true
