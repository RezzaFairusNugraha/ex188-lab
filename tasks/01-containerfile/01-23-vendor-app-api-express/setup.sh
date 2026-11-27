#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-23"
seed_var "01-23" IMG_TAG "1.2" "1.2" "1.3" "2.0"
seed_port "01-23" HOST_PORT 3023 13020 13099

WORK="$(student_home)/workspace/01-23"
rm -rf "${WORK}"
stage_vendor_app api-express "${WORK}"
podman rm -f northwind-prod >/dev/null 2>&1 || true
podman rmi -f "localhost/northwind-api:${IMG_TAG}" >/dev/null 2>&1 || true
