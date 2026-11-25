#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
WORK="$(student_home)/workspace/05-08"
podman rm -f uid-victim >/dev/null 2>&1 || true
podman rmi -f localhost/ts-web-0508:1.0 >/dev/null 2>&1 || true
podman unshare rm -rf "${WORK}" >/dev/null 2>&1 || rm -rf "${WORK}"
