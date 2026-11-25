#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f webapp-ext-0506 >/dev/null 2>&1 || true
podman rmi -f localhost/ts-web-0506:1.0 >/dev/null 2>&1 || true
run_privileged firewall-cmd --permanent --remove-port=8506/tcp >/dev/null 2>&1 || true
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true
