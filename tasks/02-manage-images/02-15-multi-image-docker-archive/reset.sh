#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rmi -f localhost/bundle-web:1.0 localhost/bundle-api:1.0 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/02-15"
