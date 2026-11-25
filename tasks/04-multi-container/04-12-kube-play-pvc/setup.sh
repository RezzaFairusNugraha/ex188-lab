#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-12"
WORK="$(student_home)/workspace/04-12"
[[ -f "${WORK}/pvc-stack.yaml" ]] && podman kube down --force "${WORK}/pvc-stack.yaml" >/dev/null 2>&1 || true
podman pod rm -f notes-kube-pod >/dev/null 2>&1 || true
podman volume rm -f notes-pvc >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}/b"

cp -a "${LAB_APPS_DIR}/webapp-flask/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp /var/lib/webapp/data && chown -R 1001:0 /opt/webapp /var/lib/webapp && chmod -R g=u /var/lib/webapp && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -q -t localhost/webapp-0412:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"
