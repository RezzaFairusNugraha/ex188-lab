#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-11"
WORK="$(student_home)/workspace/03-11"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f inspect-live inspect-crashed >/dev/null 2>&1 || true
podman network rm -f net-0311 >/dev/null 2>&1 || true

podman network create --subnet 10.89.11.0/24 net-0311 >/dev/null
podman run -d --name inspect-live --network net-0311 registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600 >/dev/null
podman run --name inspect-crashed registry.access.redhat.com/ubi10/ubi-minimal:latest sh -c 'exit 42' >/dev/null 2>&1 || true
