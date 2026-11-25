#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-11"
WORK="$(student_home)/workspace/04-11"
podman kube down "${WORK}/exported-stack.yaml" >/dev/null 2>&1 || true
podman pod rm -f export-source-pod >/dev/null 2>&1 || true
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
podman build -q -t localhost/webapp-0411:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

podman pod create --name export-source-pod -p 8411:8080 >/dev/null
podman run -d --name exp-cache --pod export-source-pod docker.io/library/redis:7-alpine >/dev/null
podman run -d --name exp-web --pod export-source-pod -e APP_ENV=production -e REDIS_HOST=127.0.0.1 localhost/webapp-0411:1.0 >/dev/null
