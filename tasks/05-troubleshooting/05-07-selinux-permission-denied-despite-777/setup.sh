#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-07"
WORK="$(student_home)/workspace/05-07"
podman rm -f selinux-victim >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}/data" "${WORK}/b"
chmod 0777 "${WORK}/data"

cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp /var/lib/webapp/data && chown -R 1001:1001 /opt/webapp /var/lib/webapp && dnf clean all
COPY --chown=1001:1001 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -q -t localhost/ts-web-0507:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

# Missing :Z -> SELinux blocks container_t from writing user_home_t even with 0777!
podman run -d --name selinux-victim -p 8507:8080 \
    -e APP_ENV=production -e CHECK_STORAGE=1 \
    -v "${WORK}/data:/var/lib/webapp/data" \
    localhost/ts-web-0507:1.0 >/dev/null
