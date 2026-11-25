#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-13"
WORK="$(student_home)/workspace/03-13"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f metrics-target >/dev/null 2>&1 || true
podman run -d --name metrics-target --user 1001 registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600 >/dev/null
