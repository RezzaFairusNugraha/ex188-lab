#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f web-client cache-primary >/dev/null 2>&1 || true
podman network rm -f app-mesh >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0401:1.0 >/dev/null 2>&1 || true
