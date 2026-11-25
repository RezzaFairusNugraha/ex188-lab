#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman pod rm -f audit-pod-0521 >/dev/null 2>&1 || true
podman network rm -f audit-net-0521 >/dev/null 2>&1 || true
podman volume rm -f audit-vol-0521 >/dev/null 2>&1 || true
podman secret rm audit-sec-0521 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/05-21"
