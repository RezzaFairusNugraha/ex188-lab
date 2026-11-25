#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "02-02"
SHOME="$(student_home)"
rm -f "${SHOME}/.config/containers/registries.conf"
mkdir -p "${SHOME}/.config/containers"
podman rmi -f localhost/fqin-verified:1.0 >/dev/null 2>&1 || true
