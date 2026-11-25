#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-04"
registry_start_all
run_privileged rm -rf "/etc/containers/certs.d/${REG_TLS_HOST}"
podman rmi -f "${REG_TLS_HOST}/qa/verified-ubi:1.0" >/dev/null 2>&1 || true
