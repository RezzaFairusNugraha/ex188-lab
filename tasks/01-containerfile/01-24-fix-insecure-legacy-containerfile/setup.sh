#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-24"
WORK="$(student_home)/workspace/01-24"
rm -rf "${WORK}"
mkdir -p "${WORK}"
cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/"

cat > "${WORK}/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3
RUN mkdir -p /opt/webapp /var/lib/webapp/data
COPY app.py requirements.txt /opt/webapp/
RUN chmod 755 /opt/webapp/app.py
ENV APP_PORT=8080
ENV APP_SECRET=HardcodedBadSecret!
WORKDIR /tmp/wrongdir
EXPOSE 8080
CMD python3 app.py
EOF

podman rm -f webapp-clean >/dev/null 2>&1 || true
podman secret rm remediated_secret >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-remediated:2.0 >/dev/null 2>&1 || true
