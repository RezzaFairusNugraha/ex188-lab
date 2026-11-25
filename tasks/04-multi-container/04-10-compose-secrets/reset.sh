#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
WORK="$(student_home)/workspace/04-10"
[[ -f "${WORK}/compose.yaml" ]] && (cd "${WORK}" && podman-compose down -v >/dev/null 2>&1 || true)
podman rm -f compose-sec-api >/dev/null 2>&1 || true
podman secret rm compose_api_tok >/dev/null 2>&1 || true
podman rmi -f localhost/api-0410:1.0 >/dev/null 2>&1 || true
rm -rf "${WORK}"
