#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-07"
WORK="$(student_home)/workspace/04-07"
podman rm -f portal-configured >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}/b"
cp -a "${LAB_APPS_DIR}/static-portal/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM quay.io/nginx/nginx-unprivileged:1.26-alpine
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
EOF
podman build -q -t localhost/static-portal:1.0 "${WORK}/b" > "${WORK}/.orig_id"
rm -rf "${WORK}/b"
