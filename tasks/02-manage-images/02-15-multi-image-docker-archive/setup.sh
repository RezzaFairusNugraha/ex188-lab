#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "02-15"
WORK="$(student_home)/workspace/02-15"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest localhost/bundle-web:1.0
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest localhost/bundle-api:1.0
