#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-14"
SHOME="$(student_home)"
QDIR="${SHOME}/.config/containers/systemd"
WORK="${SHOME}/workspace/04-14"

systemctl --user stop q-web.service q-db.service tier-net-network.service tier-pg-volume.service >/dev/null 2>&1 || true
rm -f "${QDIR}/tier-net.network" "${QDIR}/tier-pg.volume" "${QDIR}/q-db.container" "${QDIR}/q-web.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f q-web q-db >/dev/null 2>&1 || true
podman network rm -f tier-net >/dev/null 2>&1 || true
podman volume rm -f tier-pg >/dev/null 2>&1 || true

rm -rf "${WORK}"
mkdir -p "${WORK}/b"
cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp && chown -R 1001:0 /opt/webapp && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -q -t localhost/webapp-0414:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}"
