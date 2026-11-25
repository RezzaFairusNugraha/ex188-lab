#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rmi -f localhost/portal-build:ci \
    registry.lab.local:5000/web/portal:{2.3.1,2.3,2,latest} \
    registry.lab.local:5000/archive/portal:2.3.1 >/dev/null 2>&1 || true
