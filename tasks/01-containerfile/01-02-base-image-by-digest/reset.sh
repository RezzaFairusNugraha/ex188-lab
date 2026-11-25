#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rmi -f localhost/pinned-app:1.0 registry.lab.local:5000/base/ubi-pinned:stable >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/01-02"
