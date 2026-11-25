#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
podman rm -f sec-scanner >/dev/null 2>&1 || true
podman rmi -f auth-reg.lab.local:5444/sec/scanner:2.0 >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/registries.conf" "${SHOME}/.config/containers/auth.json"
run_privileged rm -rf /etc/containers/certs.d/auth-reg.lab.local:5444
