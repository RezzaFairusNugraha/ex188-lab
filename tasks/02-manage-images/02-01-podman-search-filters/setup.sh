#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-01"
registry_start_all
WORK="$(student_home)/workspace/02-01"
rm -rf "${WORK}"
mkdir -p "${WORK}"

for repo in ops/httpd-edge ops/redis-cache ops/metrics-collector; do
    podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_INSECURE_HOST}/${repo}:1.0"
    podman push --tls-verify=false "${REG_INSECURE_HOST}/${repo}:1.0" >/dev/null
    podman rmi "${REG_INSECURE_HOST}/${repo}:1.0" >/dev/null 2>&1 || true
done
