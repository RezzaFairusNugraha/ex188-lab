#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
systemctl --user stop autoweb.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/autoweb.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f autoweb systemd-autoweb >/dev/null 2>&1 || true
run_privileged rm -f /etc/containers/registries.conf.d/50-autoupdate.conf
podman rmi -f registry.lab.local:5000/ops/autoweb:prod localhost/autoweb-stage:v2 >/dev/null 2>&1 || true
