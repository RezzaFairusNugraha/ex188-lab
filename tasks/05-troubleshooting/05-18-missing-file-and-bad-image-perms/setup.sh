#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-18"
WORK="$(student_home)/workspace/05-18"
podman rm -f portal-0518 >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}"
cp -a "${LAB_APPS_DIR}/static-portal/." "${WORK}/"
chmod 0600 "${WORK}/conf/nginx.conf"

# Bug 1: .containerignore ignores *.html!
printf '*.html\n' > "${WORK}/.containerignore"
# Bug 2: COPY copies 0600 conf/nginx.conf as 0:0 (unreadable by UID 101)!
cat > "${WORK}/Containerfile" <<'EOF'
FROM quay.io/nginx/nginx-unprivileged:1.26-alpine
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
EOF
podman build -q -t localhost/ts-portal-0518:1.0 "${WORK}" >/dev/null
podman run -d --name portal-0518 -p 8518:8080 localhost/ts-portal-0518:1.0 >/dev/null 2>&1 || true
