#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rmi -f localhost/release-demo:default localhost/release-demo:prod >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/01-11"
