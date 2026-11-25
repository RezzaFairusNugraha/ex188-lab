#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-08"
registry_start_all
WORK="$(student_home)/workspace/02-08"
rm -rf "${WORK}"
mkdir -p "${WORK}"

for t in 1.0 1.1 2.0-rc1; do
    podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_INSECURE_HOST}/catalog/billing-api:${t}"
    podman push --tls-verify=false "${REG_INSECURE_HOST}/catalog/billing-api:${t}" >/dev/null
    podman rmi "${REG_INSECURE_HOST}/catalog/billing-api:${t}" >/dev/null 2>&1 || true
done
