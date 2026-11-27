#!/usr/bin/env bash
set -euo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/registry.sh"

bash "${EXAM_DIR}/reset.sh" >/dev/null 2>&1 || true
registry_start_all
SHOME="$(student_home)"
WORK="${SHOME}/workspace/m02"
mkdir -p "${WORK}/seed-dir" "${WORK}/legacy-cf" "${WORK}/se-data" "${WORK}/sec-build"
stage_vendor_app worker-py "${WORK}/worker-build"
stage_vendor_app api-express "${WORK}/api-build"

# Seed mirror image in :5443
run_privileged mkdir -p "/etc/containers/certs.d/${REG_TLS_HOST}"
run_privileged install -m 0644 "${LAB_CERTS_DIR}/ca.crt" "/etc/containers/certs.d/${REG_TLS_HOST}/ca.crt"
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_TLS_HOST}/m02/ubi-minimal:latest"
podman push --remove-signatures "${REG_TLS_HOST}/m02/ubi-minimal:latest" >/dev/null
podman rmi "${REG_TLS_HOST}/m02/ubi-minimal:latest" >/dev/null 2>&1 || true
run_privileged rm -rf "/etc/containers/certs.d/${REG_TLS_HOST}"

# Seed dir: transport + build secret + legacy Containerfile
podman push --remove-signatures -q registry.access.redhat.com/ubi10/ubi-minimal:latest "dir:${WORK}/seed-dir"
printf 'M02_BuildKey_DoNotBake_992\n' > "${WORK}/build.key"
cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/legacy-cf/"
cat > "${WORK}/legacy-cf/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3
RUN mkdir -p /opt/webapp /var/lib/webapp/data
COPY app.py requirements.txt /opt/webapp/
ENV API_SECRET=BadHardcodedSecret
CMD python3 /opt/webapp/app.py
EOF

# Broken 18, 19, 20, 21
mkdir -p "${WORK}/tmpw"
cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/tmpw/"
cat > "${WORK}/tmpw/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp /var/lib/webapp/data && chown -R 1001:1001 /opt/webapp /var/lib/webapp && dnf clean all
COPY --chown=1001:1001 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -q -t localhost/m02-ts-web:1.0 "${WORK}/tmpw" >/dev/null
rm -rf "${WORK}/tmpw"

podman run -d --name m02-selinux-fail -p 18205:8080 -e APP_ENV=production -e CHECK_STORAGE=1 -v "${WORK}/se-data:/var/lib/webapp/data" localhost/m02-ts-web:1.0 >/dev/null
podman run -d --name m02-bad-hc -p 18206:8080 --health-cmd="wget -q -O /dev/null http://127.0.0.1:80/ || exit 1" --health-retries=1 quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null
podman volume create m02-pgvol >/dev/null
podman run -d --name m02-db-loss -e POSTGRESQL_USER=u -e POSTGRESQL_PASSWORD=p -e POSTGRESQL_DATABASE=d -v m02-pgvol:/var/lib/postgresql/data quay.io/sclorg/postgresql-16-c10s:latest >/dev/null
podman pod create --name m02-fixme-pod -p 18299:8080 >/dev/null
podman run -d --name fixme-web --pod m02-fixme-pod quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null
