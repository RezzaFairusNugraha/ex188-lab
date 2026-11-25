#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-09"
WORK="$(student_home)/workspace/01-09"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rmi -f localhost/webapp-ocp-ready:1.0 >/dev/null 2>&1 || true
