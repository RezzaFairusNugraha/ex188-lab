#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-22"
WORK="$(student_home)/workspace/05-22"
[[ -f "${WORK}/remediated-pod.yaml" ]] && podman kube down "${WORK}/remediated-pod.yaml" >/dev/null 2>&1 || true
podman pod rm -f misconfigured-pod >/dev/null 2>&1 || true
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
podman build -q -t localhost/ts-web-0522:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

podman pod create --name misconfigured-pod -p 18599:8080 >/dev/null
podman run -d --name cache --pod misconfigured-pod docker.io/library/redis:7-alpine >/dev/null
podman run -d --name web --pod misconfigured-pod \
    -e APP_ENV=development -e REDIS_HOST=wrong-redis-host \
    localhost/ts-web-0522:1.0 >/dev/null
