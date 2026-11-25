#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f worker-default worker-fast >/dev/null 2>&1 || true
podman rmi -f localhost/worker-appliance:1.0 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/01-14"
