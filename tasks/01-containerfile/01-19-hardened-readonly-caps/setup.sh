#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-19"
WORK="$(student_home)/workspace/01-19"
rm -rf "${WORK}"
stage_vendor_app webapp-flask "${WORK}"
podman rm -f hardened-web >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-hardened:1.0 >/dev/null 2>&1 || true
