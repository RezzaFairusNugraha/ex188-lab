#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-02"
WORK="$(student_home)/workspace/05-02"
podman rm -f worker-0502 >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}"
cp -a "${LAB_APPS_DIR}/worker-py/." "${WORK}/"

cat > "${WORK}/start-worker.sh" <<'EOF'
#!/bin/sh
exec python3 /opt/worker/worker.py --interval 2
EOF
chmod 0644 "${WORK}/start-worker.sh"

cat > "${WORK}/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/worker /var/spool/worker/inbox /var/spool/worker/outbox && chown -R 1001:0 /opt/worker /var/spool/worker && chmod -R g=u /var/spool/worker && dnf clean all
COPY --chown=1001:0 worker.py healthcheck.py start-worker.sh /opt/worker/
USER 1001
ENTRYPOINT ["/opt/worker/start-worker.sh"]
EOF
podman build -q -t localhost/ts-worker-0502:1.0 "${WORK}" >/dev/null
podman create --name worker-0502 localhost/ts-worker-0502:1.0 >/dev/null
podman start worker-0502 >/dev/null 2>&1 || true
