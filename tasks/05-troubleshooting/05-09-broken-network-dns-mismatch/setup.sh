#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-09"
WORK="$(student_home)/workspace/05-09"
podman rm -f broken-app-0509 broken-db-0509 >/dev/null 2>&1 || true
podman network rm -f appnet-0509 >/dev/null 2>&1 || true
podman volume rm -f pgvol-0509 >/dev/null 2>&1 || true

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
# build helper
podman build -q -t localhost/ts-web-0509:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

podman network create appnet-0509 >/dev/null
podman volume create pgvol-0509 >/dev/null
# Bug 1: broken-db-0509 is on appnet-0509, but broken-app-0509 was started on default pasta network!
# Bug 2: broken-app-0509 has DB_HOST=postgres-typo instead of broken-db-0509!
podman run -d --name broken-db-0509 --network appnet-0509 -v pgvol-0509:/var/lib/pgsql/data \
    -e POSTGRESQL_USER=u -e POSTGRESQL_PASSWORD=p -e POSTGRESQL_DATABASE=d \
    quay.io/sclorg/postgresql-16-c10s:latest >/dev/null
podman run -d --name broken-app-0509 -p 8509:8080 \
    -e APP_ENV=production -e DB_HOST=postgres-typo \
    localhost/ts-web-0509:1.0 >/dev/null
