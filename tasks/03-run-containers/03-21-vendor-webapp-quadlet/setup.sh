#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-21"
seed_port "03-21" HOST_PORT 8321 18500 18599

SHOME="$(student_home)"
WORK="${SHOME}/workspace/03-21"
systemctl --user stop acme-status.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/acme-status.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f acme-status >/dev/null 2>&1 || true
podman rmi -f localhost/acme-status:1.0 >/dev/null 2>&1 || true
rm -rf "${WORK}"
stage_vendor_app webapp-flask "${WORK}/build"
