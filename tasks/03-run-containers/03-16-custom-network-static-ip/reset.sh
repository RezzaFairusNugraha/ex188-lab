#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f static-node >/dev/null 2>&1 || true
podman network rm -f corp-net >/dev/null 2>&1 || true
