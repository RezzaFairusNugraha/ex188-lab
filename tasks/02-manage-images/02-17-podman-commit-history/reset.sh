#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f hotfix-sandbox >/dev/null 2>&1 || true
podman rmi -f localhost/hotfix-snapshot:1.1 >/dev/null 2>&1 || true
