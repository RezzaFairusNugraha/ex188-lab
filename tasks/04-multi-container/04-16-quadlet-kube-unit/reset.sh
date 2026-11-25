#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
systemctl --user stop qkube-app.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/qkube-app.kube"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman pod rm -f qkube-pod >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0416:1.0 >/dev/null 2>&1 || true
rm -rf "${SHOME}/workspace/04-16"
