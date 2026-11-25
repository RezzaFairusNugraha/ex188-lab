#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-18"
WORK="$(student_home)/workspace/01-18"
podman rm -f worker-unshare worker-keepid >/dev/null 2>&1 || true
podman unshare rm -rf "${WORK}" >/dev/null 2>&1 || rm -rf "${WORK}"
mkdir -p "${WORK}/build"
podman rmi -f localhost/worker-uid1001:1.0 >/dev/null 2>&1 || true
