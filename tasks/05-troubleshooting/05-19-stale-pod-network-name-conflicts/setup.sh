#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-19"
WORK="$(student_home)/workspace/05-19"
podman pod rm -f orders-pod >/dev/null 2>&1 || true
podman rm -f orders-web orders-cache do-not-touch-0519 >/dev/null 2>&1 || true
podman network rm -f orders-net stale-subnet-50 >/dev/null 2>&1 || true

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
podman build -q -t localhost/ts-web-0519:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

# Legit container that MUST survive
podman run -d --name do-not-touch-0519 registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600 >/dev/null

# Stale conflicting objects:
podman network create --subnet 10.89.50.0/24 stale-subnet-50 >/dev/null
podman pod create --name orders-pod >/dev/null
podman create --name orders-web registry.access.redhat.com/ubi10/ubi-minimal:latest true >/dev/null

cat > "${WORK}/deploy-stack.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
podman network create --subnet 10.89.50.0/24 orders-net
podman pod create --name orders-pod --network orders-net -p 8519:8080
podman run -d --name orders-cache --pod orders-pod docker.io/library/redis:7-alpine
podman run -d --name orders-web --pod orders-pod -e APP_ENV=production -e REDIS_HOST=127.0.0.1 localhost/ts-web-0519:1.0
EOF
chmod 0755 "${WORK}/deploy-stack.sh"
