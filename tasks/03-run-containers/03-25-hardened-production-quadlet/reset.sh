#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
systemctl --user stop prod-metrics.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/prod-metrics.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f prod-metrics >/dev/null 2>&1 || true
run_privileged rm -rf /etc/containers/certs.d/secure-reg.lab.local:5443
run_privileged firewall-cmd --permanent --remove-port=9325/tcp >/dev/null 2>&1 || true
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true
