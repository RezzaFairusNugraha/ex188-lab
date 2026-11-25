#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SUSER="$(student_user)"
SHOME="$(student_home)"
systemctl --user stop critical-api.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/critical-api.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f critical-api >/dev/null 2>&1 || true
run_privileged loginctl enable-linger "${SUSER}" >/dev/null 2>&1 || true
