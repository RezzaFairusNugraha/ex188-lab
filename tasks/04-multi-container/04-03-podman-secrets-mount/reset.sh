#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f sec-mount-api >/dev/null 2>&1 || true
podman secret rm nw_token >/dev/null 2>&1 || true
podman rmi -f localhost/api-0403:1.0 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/04-03"
