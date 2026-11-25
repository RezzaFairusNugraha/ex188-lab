#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-13"
WORK="$(student_home)/workspace/04-13"
[[ -f "${WORK}/cm-secret-pod.yaml" ]] && podman kube down "${WORK}/cm-secret-pod.yaml" >/dev/null 2>&1 || true
podman pod rm -f cm-sec-pod >/dev/null 2>&1 || true
podman secret rm webapp-k8s-sec >/dev/null 2>&1 || true
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
podman build -q -t localhost/webapp-0413:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"
