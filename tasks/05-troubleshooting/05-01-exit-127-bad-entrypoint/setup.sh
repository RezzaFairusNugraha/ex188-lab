#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-01"
WORK="$(student_home)/workspace/05-01"
podman rm -f broken-web-0501 >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}/b"

cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp && chown -R 1001:0 /opt/webapp && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
ENTRYPOINT ["/usr/bin/python3-nonexistent", "/opt/webapp/app.py"]
EOF
podman build -q -t localhost/ts-web-0501:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

podman create --name broken-web-0501 -p 8501:8080 -e APP_ENV=production localhost/ts-web-0501:1.0 >/dev/null
podman start broken-web-0501 >/dev/null 2>&1 || true
