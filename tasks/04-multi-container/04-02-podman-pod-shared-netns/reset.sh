#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman pod rm -f portal-pod >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0402:1.0 >/dev/null 2>&1 || true
