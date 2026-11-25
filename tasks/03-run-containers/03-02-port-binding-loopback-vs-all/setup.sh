#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-02"
seed_port "03-02" PUB_PORT 18082 18200 18299

WORK="$(student_home)/workspace/03-02"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f admin-local public-front >/dev/null 2>&1 || true
