#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-10"
WORK="$(student_home)/workspace/03-10"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f event-probe >/dev/null 2>&1 || true
