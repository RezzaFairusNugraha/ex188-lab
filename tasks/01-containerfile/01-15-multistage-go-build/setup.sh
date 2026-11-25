#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-15"
seed_port "01-15" HOST_PORT 9190 19100 19199

WORK="$(student_home)/workspace/01-15"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f metrics-agent >/dev/null 2>&1 || true
podman rmi -f localhost/metrics-go:1.0 >/dev/null 2>&1 || true
