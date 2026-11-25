#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f inspect-live inspect-crashed >/dev/null 2>&1 || true
podman network rm -f net-0311 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/03-11"
