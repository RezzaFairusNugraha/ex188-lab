#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-06"
WORK="$(student_home)/workspace/04-06"
podman rm -f job-consumer job-producer >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}/b"
cp -a "${LAB_APPS_DIR}/worker-py/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/worker /var/spool/worker/inbox /var/spool/worker/outbox && chown -R 1001:1001 /opt/worker /var/spool/worker && dnf clean all
COPY --chown=1001:1001 worker.py healthcheck.py /opt/worker/
USER 1001
CMD ["python3", "/opt/worker/worker.py", "--interval", "1"]
EOF
podman build -q -t localhost/worker-0406:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"
