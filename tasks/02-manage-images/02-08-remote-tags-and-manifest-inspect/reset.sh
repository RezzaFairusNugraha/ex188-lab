#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rmi -f registry.lab.local:5000/catalog/billing-api:{1.0,1.1,2.0-rc1} >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/02-08"
