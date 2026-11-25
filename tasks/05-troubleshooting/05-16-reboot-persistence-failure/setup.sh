#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-16"
SUSER="$(student_user)"
SHOME="$(student_home)"
QDIR="${SHOME}/.config/containers/systemd"

systemctl --user stop critical-api.service >/dev/null 2>&1 || true
mkdir -p "${QDIR}"
# Bug 1: WantedBy=multi-user.target (doesn't trigger in --user systemd!)
# Bug 2: Linger disabled!
cat > "${QDIR}/critical-api.container" <<'EOF'
[Unit]
Description=Critical Reboot-Persistent API

[Container]
Image=quay.io/nginx/nginx-unprivileged:1.26-alpine
ContainerName=critical-api
PublishPort=8516:8080

[Service]
Restart=always

[Install]
WantedBy=multi-user.target
EOF
run_privileged loginctl disable-linger "${SUSER}" >/dev/null 2>&1 || true
systemctl --user daemon-reload
systemctl --user start critical-api.service >/dev/null 2>&1 || true
