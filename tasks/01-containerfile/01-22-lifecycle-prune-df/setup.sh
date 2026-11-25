#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-22"
WORK="$(student_home)/workspace/01-22"
rm -rf "${WORK}"
mkdir -p "${WORK}/dangling"

podman rm -f keep-alive-svc exited-job-1 exited-job-2 >/dev/null 2>&1 || true
podman run -d --name keep-alive-svc registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600 >/dev/null
podman run --name exited-job-1 registry.access.redhat.com/ubi10/ubi-minimal:latest true >/dev/null
podman run --name exited-job-2 registry.access.redhat.com/ubi10/ubi-minimal:latest true >/dev/null

cat > "${WORK}/dangling/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN echo "layer-v1" > /etc/dangling-marker
EOF
podman build -q -t localhost/retag-temp:1.0 "${WORK}/dangling" >/dev/null
cat > "${WORK}/dangling/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN echo "layer-v2" > /etc/dangling-marker
EOF
podman build -q -t localhost/retag-temp:1.0 "${WORK}/dangling" >/dev/null
rm -rf "${WORK}/dangling"
