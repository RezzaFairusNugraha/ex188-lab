#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-15"
SHOME="$(student_home)"
systemctl --user stop broken-quad.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/broken-quad.container" "${SHOME}/.config/systemd/user/broken-quad.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f broken-quad >/dev/null 2>&1 || true

# Bug 1: Placed in ~/.config/systemd/user/ instead of ~/.config/containers/systemd/
# Bug 2: [Containers] plural instead of [Container]
# Bug 3: Ports=8515:8080 instead of PublishPort=8515:8080
mkdir -p "${SHOME}/.config/systemd/user"
cat > "${SHOME}/.config/systemd/user/broken-quad.container" <<'EOF'
[Unit]
Description=Broken Quadlet Exercise

[Containers]
Image=quay.io/nginx/nginx-unprivileged:1.26-alpine
ContainerName=broken-quad
Ports=8515:8080

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF
