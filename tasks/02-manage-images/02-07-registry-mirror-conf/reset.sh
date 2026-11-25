#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
run_privileged rm -f /etc/containers/registries.conf.d/60-corp-mirror.conf
run_privileged rm -rf /etc/containers/certs.d/secure-reg.lab.local:5443
podman rmi -f upstream-hub.corp.example/platform/agent:2.1 >/dev/null 2>&1 || true
