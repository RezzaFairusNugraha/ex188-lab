#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
run_privileged rm -rf /etc/containers/certs.d/auth-reg.lab.local:5444
rm -f "$(student_home)/.config/containers/auth.json"
podman logout auth-reg.lab.local:5444 >/dev/null 2>&1 || true
podman rmi -f auth-reg.lab.local:5444/prod/core-ubi:1.0 >/dev/null 2>&1 || true
