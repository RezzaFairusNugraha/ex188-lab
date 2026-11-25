#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
WORK="$(student_home)/workspace/04-12"
[[ -f "${WORK}/pvc-stack.yaml" ]] && podman kube down --force "${WORK}/pvc-stack.yaml" >/dev/null 2>&1 || true
podman pod rm -f notes-kube-pod >/dev/null 2>&1 || true
podman volume rm -f notes-pvc >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0412:1.0 >/dev/null 2>&1 || true
rm -rf "${WORK}"
