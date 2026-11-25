#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-03"
WORK="$(student_home)/workspace/01-03"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rmi -f localhost/minimal-archiver:1.0 >/dev/null 2>&1 || true
