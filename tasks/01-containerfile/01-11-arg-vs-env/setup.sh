#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-11"
seed_var "01-11" PROD_REL "2.4.0" "2.4.0" "2.5.1" "3.1.0"

WORK="$(student_home)/workspace/01-11"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rmi -f localhost/release-demo:default localhost/release-demo:prod >/dev/null 2>&1 || true
