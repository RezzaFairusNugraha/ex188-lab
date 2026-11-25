#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
seed_load "01-01"
podman rmi -f "localhost/${IMAGE_NAME:-ubi10-httpd}:${IMAGE_TAG:-1.0}" >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/01-01"
