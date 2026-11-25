#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "01-02"
registry_start_all
WORK="$(student_home)/workspace/01-02"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rmi -f localhost/pinned-app:1.0 >/dev/null 2>&1 || true

if ! podman image exists registry.access.redhat.com/ubi10/ubi-minimal:latest 2>/dev/null; then
    podman pull registry.access.redhat.com/ubi10/ubi-minimal:latest >/dev/null
fi
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_INSECURE_HOST}/base/ubi-pinned:stable"
podman push --tls-verify=false "${REG_INSECURE_HOST}/base/ubi-pinned:stable" >/dev/null
