#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
WORK="$(student_home)/workspace/04-11"
[[ -f "${WORK}/exported-stack.yaml" ]] && podman kube down "${WORK}/exported-stack.yaml" >/dev/null 2>&1 || true
podman pod rm -f export-source-pod >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0411:1.0 >/dev/null 2>&1 || true
rm -rf "${WORK}"
