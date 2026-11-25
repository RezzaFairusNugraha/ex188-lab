#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
systemctl --user stop broken-quad.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/broken-quad.container" "${SHOME}/.config/systemd/user/broken-quad.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f broken-quad >/dev/null 2>&1 || true
