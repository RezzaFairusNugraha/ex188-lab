#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-16"
podman rm -f static-node >/dev/null 2>&1 || true
podman network rm -f corp-net >/dev/null 2>&1 || true
