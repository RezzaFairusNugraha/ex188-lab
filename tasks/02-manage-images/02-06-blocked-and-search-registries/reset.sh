#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
rm -f "$(student_home)/.config/containers/registries.conf"
run_privileged rm -rf /etc/containers/certs.d/secure-reg.lab.local:5443
podman rmi -f localhost/mini-tool:verified secure-reg.lab.local:5443/approved/mini-tool:1.0 >/dev/null 2>&1 || true
