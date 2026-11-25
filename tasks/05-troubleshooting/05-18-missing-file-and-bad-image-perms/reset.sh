#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f portal-0518 >/dev/null 2>&1 || true
podman rmi -f localhost/ts-portal-0518:1.0 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/05-18"
