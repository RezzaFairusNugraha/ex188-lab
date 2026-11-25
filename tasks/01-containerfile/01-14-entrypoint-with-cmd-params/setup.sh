#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-14"
WORK="$(student_home)/workspace/01-14"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f worker-default worker-fast >/dev/null 2>&1 || true
podman rmi -f localhost/worker-appliance:1.0 >/dev/null 2>&1 || true
