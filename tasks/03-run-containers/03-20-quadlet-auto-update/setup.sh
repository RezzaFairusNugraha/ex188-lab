#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "03-20"
registry_start_all
SHOME="$(student_home)"
WORK="${SHOME}/workspace/03-20"
systemctl --user stop autoweb.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/autoweb.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f autoweb >/dev/null 2>&1 || true
run_privileged rm -f /etc/containers/registries.conf.d/50-autoupdate.conf

rm -rf "${WORK}"
mkdir -p "${WORK}/v1" "${WORK}/v2"
cat > "${WORK}/v1/Containerfile" <<'EOF'
FROM quay.io/nginx/nginx-unprivileged:1.26-alpine
RUN echo "REL-V1" > /usr/share/nginx/html/index.html
EOF
cat > "${WORK}/v2/Containerfile" <<'EOF'
FROM quay.io/nginx/nginx-unprivileged:1.26-alpine
RUN echo "REL-V2" > /usr/share/nginx/html/index.html
EOF
podman build -q -t "${REG_INSECURE_HOST}/ops/autoweb:prod" "${WORK}/v1" >/dev/null
podman push --tls-verify=false "${REG_INSECURE_HOST}/ops/autoweb:prod" >/dev/null
podman build -q -t localhost/autoweb-stage:v2 "${WORK}/v2" >/dev/null
rm -rf "${WORK}"
