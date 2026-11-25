#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-17"
WORK="$(student_home)/workspace/01-17"
rm -rf "${WORK}"
mkdir -p "${WORK}/build"
podman rm -f inventory-api >/dev/null 2>&1 || true
podman volume rm -f api-audit-vol >/dev/null 2>&1 || true
podman rmi -f localhost/api-express:1.0 >/dev/null 2>&1 || true
