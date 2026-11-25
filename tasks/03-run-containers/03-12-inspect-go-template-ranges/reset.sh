#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f complex-meta >/dev/null 2>&1 || true
podman volume rm -f meta-vol-0312 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/03-12"
