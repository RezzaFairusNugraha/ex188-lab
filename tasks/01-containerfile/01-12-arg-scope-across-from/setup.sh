#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-12"
WORK="$(student_home)/workspace/01-12"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f scoped-runner >/dev/null 2>&1 || true
podman rmi -f localhost/scoped-ubi:1.0 >/dev/null 2>&1 || true
