#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
seed_load "01-23"
podman rm -f northwind-prod >/dev/null 2>&1 || true
podman secret rm nw_api_token >/dev/null 2>&1 || true
podman rmi -f "localhost/northwind-api:${IMG_TAG:-1.2}" >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/01-23"
