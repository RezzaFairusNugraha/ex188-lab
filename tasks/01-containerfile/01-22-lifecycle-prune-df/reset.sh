#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f keep-alive-svc exited-job-1 exited-job-2 >/dev/null 2>&1 || true
podman rmi -f localhost/retag-temp:1.0 >/dev/null 2>&1 || true
podman image prune -f >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/01-22"
