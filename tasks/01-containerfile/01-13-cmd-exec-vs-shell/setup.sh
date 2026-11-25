#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-13"
WORK="$(student_home)/workspace/01-13"
rm -rf "${WORK}"
mkdir -p "${WORK}"
cp -a "${LAB_APPS_DIR}/worker-py/." "${WORK}/"

cat > "${WORK}/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/worker /var/spool/worker/inbox /var/spool/worker/outbox \
    && chown -R 1001:0 /opt/worker /var/spool/worker \
    && chmod -R g=u /opt/worker /var/spool/worker \
    && dnf clean all
COPY --chown=1001:0 worker.py healthcheck.py /opt/worker/
USER 1001
CMD python3 /opt/worker/worker.py
EOF

podman rm -f worker-clean >/dev/null 2>&1 || true
podman rmi -f localhost/worker-exec:1.0 >/dev/null 2>&1 || true
