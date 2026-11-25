#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-24"
SUSER="$(student_user)"
SHOME="$(student_home)"
WORK="${SHOME}/workspace/03-24"

systemctl --user stop journal-web.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/journal-web.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f journal-web >/dev/null 2>&1 || true
run_privileged rm -rf /srv/student-journal
run_privileged mkdir -p /srv/student-journal
run_privileged chown "${SUSER}:${SUSER}" /srv/student-journal

rm -rf "${WORK}"
mkdir -p "${WORK}/b"
cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp /var/lib/webapp/data && chown -R 1001:1001 /opt/webapp /var/lib/webapp && dnf clean all
COPY --chown=1001:1001 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -q -t localhost/webapp-0324:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}"
