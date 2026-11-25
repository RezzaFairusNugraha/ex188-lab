#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f agent-0510 >/dev/null 2>&1 || true
podman rmi -f secure-reg.lab.local:5443/ops/agent-0510:1.0 >/dev/null 2>&1 || true
run_privileged rm -rf /etc/containers/certs.d/secure-reg.lab.local /etc/containers/certs.d/secure-reg.lab.local:5443
