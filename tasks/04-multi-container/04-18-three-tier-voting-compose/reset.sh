#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
WORK="$(student_home)/workspace/04-18"
[[ -f "${WORK}/compose.yaml" ]] && (cd "${WORK}" && podman-compose down -v >/dev/null 2>&1 || true)
podman rm -f vote-ui vote-api vote-db vote-cache >/dev/null 2>&1 || true
podman secret rm voting_db_secret >/dev/null 2>&1 || true
podman rmi -f localhost/vote-ui:1.0 localhost/vote-api:1.0 >/dev/null 2>&1 || true
rm -rf "${WORK}"
