#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "02-16"
WORK="$(student_home)/workspace/02-16"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f legacy-box >/dev/null 2>&1 || true
podman rmi -f localhost/flattened-box:1.0 >/dev/null 2>&1 || true

podman run --name legacy-box registry.access.redhat.com/ubi10/ubi-minimal:latest \
    sh -c 'echo stamp-0216 > /etc/custom-stamp'
