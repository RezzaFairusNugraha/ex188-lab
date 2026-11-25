#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f prod-portal-0504 rogue-squatter-0504 legit-neighbor-0504 >/dev/null 2>&1 || true
