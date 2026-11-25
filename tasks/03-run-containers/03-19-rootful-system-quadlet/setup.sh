#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-19"
run_privileged systemctl stop sys-gateway.service >/dev/null 2>&1 || true
run_privileged rm -f /etc/containers/systemd/sys-gateway.container
run_privileged systemctl daemon-reload
run_privileged podman rm -f sys-gateway >/dev/null 2>&1 || true
run_privileged firewall-cmd --permanent --remove-port=8089/tcp >/dev/null 2>&1 || true
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true
