#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman pod rm -f orders-pod >/dev/null 2>&1 || true
podman rm -f orders-web orders-cache do-not-touch-0519 >/dev/null 2>&1 || true
podman network rm -f orders-net stale-subnet-50 >/dev/null 2>&1 || true
podman rmi -f localhost/ts-web-0519:1.0 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/05-19"
