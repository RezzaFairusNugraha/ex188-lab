#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "02-19"
WORK="$(student_home)/workspace/02-19"
rm -rf "${WORK}"
mkdir -p "${WORK}/unpacked-dir"
podman rmi -f localhost/from-dir:1.0 localhost/from-oci:1.0 >/dev/null 2>&1 || true

podman push -q registry.access.redhat.com/ubi10/ubi-minimal:latest "dir:${WORK}/unpacked-dir"
podman push -q registry.access.redhat.com/ubi10/ubi-minimal:latest "oci-archive:${WORK}/bundle-oci.tar:localhost/from-oci:1.0"
