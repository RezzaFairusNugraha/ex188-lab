#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f broken-web-0501 >/dev/null 2>&1 || true
podman rmi -f localhost/ts-web-0501:1.0 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/05-01"
