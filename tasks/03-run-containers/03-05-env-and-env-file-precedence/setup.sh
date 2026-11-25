#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-05"
WORK="$(student_home)/workspace/03-05"
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
podman rm -f env-precedence >/dev/null 2>&1 || true
podman build -q -t localhost/webapp-envtest:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

cat > "${WORK}/base.env" <<'EOF'
APP_ENV=staging
APP_PORT=8080
LOG_LEVEL=warn
EOF
