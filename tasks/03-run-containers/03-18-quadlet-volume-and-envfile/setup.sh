#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-18"
SHOME="$(student_home)"
WORK="${SHOME}/workspace/03-18"
systemctl --user stop notes-quad.service notes-store-volume.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/notes-quad.container" "${SHOME}/.config/containers/systemd/notes-store.volume"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f notes-quad >/dev/null 2>&1 || true
podman volume rm -f notes-store >/dev/null 2>&1 || true

rm -rf "${WORK}"
mkdir -p "${WORK}/b"
cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp /var/lib/webapp/data && chown -R 1001:0 /opt/webapp /var/lib/webapp && chmod -R g=u /var/lib/webapp && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -q -t localhost/webapp-0318:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"
