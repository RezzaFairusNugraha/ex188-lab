#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
systemctl --user stop acme-status.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/acme-status.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f acme-status >/dev/null 2>&1 || true
podman rmi -f localhost/acme-status:1.0 >/dev/null 2>&1 || true
rm -rf "${SHOME}/workspace/03-21"
