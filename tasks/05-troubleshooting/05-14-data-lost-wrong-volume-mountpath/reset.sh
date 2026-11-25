#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f orders-db >/dev/null 2>&1 || true
podman volume rm -f orders-pgvol >/dev/null 2>&1 || true
