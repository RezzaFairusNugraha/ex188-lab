#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
WORK="$(student_home)/workspace/04-13"
[[ -f "${WORK}/cm-secret-pod.yaml" ]] && podman kube down "${WORK}/cm-secret-pod.yaml" >/dev/null 2>&1 || true
podman pod rm -f cm-sec-pod >/dev/null 2>&1 || true
podman secret rm webapp-k8s-sec >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0413:1.0 >/dev/null 2>&1 || true
rm -rf "${WORK}"
