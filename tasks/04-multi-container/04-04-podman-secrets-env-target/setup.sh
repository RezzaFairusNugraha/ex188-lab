#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-04"
podman rm -f secure-pg >/dev/null 2>&1 || true
podman secret rm pg_admin_pass >/dev/null 2>&1 || true
podman volume rm -f pgdata-0404 >/dev/null 2>&1 || true
