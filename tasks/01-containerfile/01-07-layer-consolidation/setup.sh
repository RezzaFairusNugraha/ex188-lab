#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-07"
WORK="$(student_home)/workspace/01-07"
rm -rf "${WORK}"
mkdir -p "${WORK}"

cat > "${WORK}/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3
RUN dd if=/dev/zero of=/tmp/stage.bin bs=1M count=50
RUN printf 'ex188-seed' | sha256sum | awk '{print $1}' > /etc/app-checksum
RUN rm -f /tmp/stage.bin
RUN dnf clean all
USER 1001
CMD ["python3", "--version"]
EOF

podman rmi -f localhost/lean-python:1.0 localhost/bloated-python:legacy >/dev/null 2>&1 || true
podman build -q -t localhost/bloated-python:legacy "${WORK}" >/dev/null 2>&1 || true
