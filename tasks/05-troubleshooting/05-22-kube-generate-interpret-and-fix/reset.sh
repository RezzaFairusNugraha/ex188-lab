#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
WORK="$(student_home)/workspace/05-22"
[[ -f "${WORK}/remediated-pod.yaml" ]] && podman kube down "${WORK}/remediated-pod.yaml" >/dev/null 2>&1 || true
podman pod rm -f misconfigured-pod >/dev/null 2>&1 || true
podman rmi -f localhost/ts-web-0522:1.0 >/dev/null 2>&1 || true
rm -rf "${WORK}"
