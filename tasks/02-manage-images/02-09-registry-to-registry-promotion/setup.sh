#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-09"
seed_var "02-09" REL_TAG "1.4" "1.4" "1.5" "2.0"
registry_start_all

podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_INSECURE_HOST}/staging/order-worker:rc4"
podman push --remove-signatures --tls-verify=false "${REG_INSECURE_HOST}/staging/order-worker:rc4" >/dev/null
podman rmi -f "${REG_INSECURE_HOST}/staging/order-worker:rc4" "${REG_TLS_HOST}/release/order-worker:${REL_TAG}" >/dev/null 2>&1 || true
