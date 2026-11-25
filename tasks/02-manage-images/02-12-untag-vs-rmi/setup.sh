#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "02-12"
WORK="$(student_home)/workspace/02-12"
rm -rf "${WORK}"
mkdir -p "${WORK}/a" "${WORK}/b"

cat > "${WORK}/a/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN echo "image-A-keep-id" > /etc/marker-a
EOF
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN echo "image-B-delete-id" > /etc/marker-b
EOF

podman build -q -t localhost/keep-layers:1.0 -t localhost/keep-layers:temp "${WORK}/a" > "${WORK}/.id_a"
podman build -q -t localhost/purge-completely:1.0 "${WORK}/b" > "${WORK}/.id_b"
rm -rf "${WORK}/a" "${WORK}/b"
