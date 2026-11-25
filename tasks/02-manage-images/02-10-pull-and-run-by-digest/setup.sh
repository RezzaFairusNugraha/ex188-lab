#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-10"
registry_start_all
WORK="$(student_home)/workspace/02-10"
rm -rf "${WORK}"
mkdir -p "${WORK}/b1" "${WORK}/b2"
podman rm -f digest-runner >/dev/null 2>&1 || true

cat > "${WORK}/b1/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN echo "GOOD_V1" > /etc/audit-release
USER 1001
EOF
cat > "${WORK}/b2/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN echo "DECOY_LATEST" > /etc/audit-release
USER 1001
EOF

podman build -q -t "${REG_INSECURE_HOST}/sec/audit-runner:v1" "${WORK}/b1" >/dev/null
podman push --remove-signatures --tls-verify=false "${REG_INSECURE_HOST}/sec/audit-runner:v1" --digestfile "${WORK}/.expected-digest" >/dev/null
podman build -q -t "${REG_INSECURE_HOST}/sec/audit-runner:latest" "${WORK}/b2" >/dev/null
podman push --remove-signatures --tls-verify=false "${REG_INSECURE_HOST}/sec/audit-runner:latest" >/dev/null
podman rmi -f "${REG_INSECURE_HOST}/sec/audit-runner:v1" "${REG_INSECURE_HOST}/sec/audit-runner:latest" >/dev/null 2>&1 || true
rm -rf "${WORK}/b1" "${WORK}/b2"
