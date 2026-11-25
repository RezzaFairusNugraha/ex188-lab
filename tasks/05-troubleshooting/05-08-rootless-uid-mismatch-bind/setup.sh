#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-08"
WORK="$(student_home)/workspace/05-08"
podman rm -f uid-victim >/dev/null 2>&1 || true
podman unshare rm -rf "${WORK}" >/dev/null 2>&1 || rm -rf "${WORK}"
mkdir -p "${WORK}/journal" "${WORK}/b"
chmod 0755 "${WORK}/journal"

cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp /var/lib/webapp/data && chown -R 1001:1001 /opt/webapp /var/lib/webapp && dnf clean all
COPY --chown=1001:1001 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -q -t localhost/ts-web-0508:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

podman run -d --name uid-victim -p 8508:8080 -e APP_ENV=production \
    -v "${WORK}/journal:/var/lib/webapp/data:Z" \
    localhost/ts-web-0508:1.0 >/dev/null
