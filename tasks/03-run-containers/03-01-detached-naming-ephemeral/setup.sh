#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-01"
seed_var "03-01" CNAME "beacon-svc" "beacon-svc" "pulse-svc" "sentinel-svc"

WORK="$(student_home)/workspace/03-01"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f "${CNAME}" >/dev/null 2>&1 || true
podman container prune -f >/dev/null 2>&1 || true
