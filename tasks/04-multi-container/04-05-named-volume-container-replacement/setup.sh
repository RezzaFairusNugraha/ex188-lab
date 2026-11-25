#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-05"
podman rm -f customers-db-v1 customers-db-v2 >/dev/null 2>&1 || true
podman volume rm -f customers-pgvol >/dev/null 2>&1 || true
