#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-22"
SHOME="$(student_home)"
systemctl --user disable --now container-legacy-cache.service >/dev/null 2>&1 || true
systemctl --user stop legacy-cache.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/systemd/user/container-legacy-cache.service" "${SHOME}/.config/containers/systemd/legacy-cache.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f legacy-cache >/dev/null 2>&1 || true
podman volume rm -f legacy-redis-data >/dev/null 2>&1 || true

podman volume create legacy-redis-data >/dev/null
podman run -d --name seed-redis -v legacy-redis-data:/data docker.io/library/redis:7-alpine redis-server --appendonly yes >/dev/null
sleep 2
podman exec seed-redis redis-cli SET MIGRATION_CHECK PRESERVED_99 >/dev/null
podman exec seed-redis redis-cli SAVE >/dev/null
podman rm -f seed-redis >/dev/null

mkdir -p "${SHOME}/.config/systemd/user"
cat > "${SHOME}/.config/systemd/user/container-legacy-cache.service" <<'EOF'
# DEPRECATED unit previously created by podman generate systemd --new
[Unit]
Description=Deprecated Redis Unit

[Service]
ExecStart=/usr/bin/podman run --rm --replace -d --name legacy-cache -p 127.0.0.1:16379:6379 --memory 128m -v legacy-redis-data:/data docker.io/library/redis:7-alpine redis-server --appendonly yes
ExecStop=/usr/bin/podman stop -t 10 legacy-cache
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable --now container-legacy-cache.service >/dev/null 2>&1 || true
