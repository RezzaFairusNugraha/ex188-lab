#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
rm -f "$(student_home)/.config/containers/registries.conf"
podman rmi -f localhost/fqin-verified:1.0 >/dev/null 2>&1 || true
