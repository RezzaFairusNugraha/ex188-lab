#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-04"
podman rm -f lowport-web >/dev/null 2>&1 || true
run_privileged rm -f /etc/sysctl.d/90-ex188-lowports.conf
run_privileged sysctl -w net.ipv4.ip_unprivileged_port_start=1024 >/dev/null
run_privileged firewall-cmd --permanent --remove-port=808/tcp >/dev/null 2>&1 || true
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true
