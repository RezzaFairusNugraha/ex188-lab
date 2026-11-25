#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
seed_load "02-09"
podman rmi -f registry.lab.local:5000/staging/order-worker:rc4 "secure-reg.lab.local:5443/release/order-worker:${REL_TAG:-1.4}" >/dev/null 2>&1 || true
