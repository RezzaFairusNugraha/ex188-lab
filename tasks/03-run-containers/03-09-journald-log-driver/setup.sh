#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-09"
WORK="$(student_home)/workspace/03-09"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f journal-auditor >/dev/null 2>&1 || true
