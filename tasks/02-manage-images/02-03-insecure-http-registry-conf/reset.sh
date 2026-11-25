#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
run_privileged rm -f /etc/containers/registries.conf.d/50-lab-http.conf
podman rmi -f registry.lab.local:5000/dev/base-ubi:1.0 >/dev/null 2>&1 || true
