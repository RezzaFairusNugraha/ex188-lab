#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
run_privileged rm -rf /etc/containers/certs.d/secure-reg.lab.local:5443
podman rmi -f secure-reg.lab.local:5443/qa/verified-ubi:1.0 >/dev/null 2>&1 || true
