#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-12"
WORK="$(student_home)/workspace/03-12"
rm -rf "${WORK}"
mkdir -p "${WORK}/cfg"
printf 'ok\n' > "${WORK}/cfg/app.ini"

podman rm -f complex-meta >/dev/null 2>&1 || true
podman volume rm -f meta-vol-0312 >/dev/null 2>&1 || true
podman volume create meta-vol-0312 >/dev/null

podman run -d --name complex-meta \
    --label "com.acme.cost-center=CC-8841-RHEL" \
    -e FEATURE_BILLING=enabled \
    -e FEATURE_SEARCH=beta \
    -e INTERNAL_NOISE=ignore \
    -v "${WORK}/cfg:/etc/meta-cfg:ro,z" \
    -v meta-vol-0312:/var/lib/meta-data \
    registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600 >/dev/null
