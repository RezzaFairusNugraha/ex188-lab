#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-17"
seed_port "03-17" HOST_PORT 8317 18310 18399

SHOME="$(student_home)"
systemctl --user stop portal-quad.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/portal-quad.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f portal-quad >/dev/null 2>&1 || true
