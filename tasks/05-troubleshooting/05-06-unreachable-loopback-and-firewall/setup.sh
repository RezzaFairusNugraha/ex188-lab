#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-06"
WORK="$(student_home)/workspace/05-06"
podman rm -f webapp-ext-0506 >/dev/null 2>&1 || true
run_privileged firewall-cmd --permanent --remove-port=8506/tcp >/dev/null 2>&1 || true
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true

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
podman build -q -t localhost/ts-web-0506:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}"

podman run -d --name webapp-ext-0506 -p 127.0.0.1:8506:8080 \
    -e APP_ENV=production -e APP_BIND=127.0.0.1 localhost/ts-web-0506:1.0 >/dev/null
