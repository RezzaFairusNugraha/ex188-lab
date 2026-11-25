#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f retry-bounded retry-always >/dev/null 2>&1 || true
systemctl --user disable podman-restart.service >/dev/null 2>&1 || true
