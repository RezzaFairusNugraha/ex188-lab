#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-21"
WORK="$(student_home)/workspace/01-21"
rm -rf "${WORK}"
stage_vendor_app worker-py "${WORK}"
podman rm -f worker-hc >/dev/null 2>&1 || true
podman rmi -f localhost/worker-labeled:1.0 >/dev/null 2>&1 || true
