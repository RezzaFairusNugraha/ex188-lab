#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f metrics-broken-port >/dev/null 2>&1 || true
podman rmi -f localhost/ts-metrics-0505:1.0 >/dev/null 2>&1 || true
