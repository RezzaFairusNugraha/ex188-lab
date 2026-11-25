#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-03"
seed_port "03-03" EXT_PORT 8883 18880 18899

podman rm -f edge-portal >/dev/null 2>&1 || true
run_privileged firewall-cmd --permanent --remove-port="${EXT_PORT}/tcp" >/dev/null 2>&1 || true
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true
