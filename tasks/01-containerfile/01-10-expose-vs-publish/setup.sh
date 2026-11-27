#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-10"
seed_port "01-10" HOST_PORT 8091 18100 18199

WORK="$(student_home)/workspace/01-10"
rm -rf "${WORK}"
stage_vendor_app static-portal "${WORK}"
podman rm -f portal-explicit portal-auto >/dev/null 2>&1 || true
podman rmi -f localhost/portal-expose:1.0 >/dev/null 2>&1 || true
