#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f selinux-victim >/dev/null 2>&1 || true
podman rmi -f localhost/ts-web-0507:1.0 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/05-07"
