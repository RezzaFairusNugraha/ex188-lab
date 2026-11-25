#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
systemctl --user stop notes-quad.service notes-store-volume.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/notes-quad.container" "${SHOME}/.config/containers/systemd/notes-store.volume"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f notes-quad >/dev/null 2>&1 || true
podman volume rm -f notes-store >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0318:1.0 >/dev/null 2>&1 || true
rm -rf "${SHOME}/workspace/03-18"
