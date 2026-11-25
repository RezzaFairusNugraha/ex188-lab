#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f catalog-svc >/dev/null 2>&1 || true
podman rmi -f registry.lab.local:5000/inventory/catalog-svc:2.1.0 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/05-12"
