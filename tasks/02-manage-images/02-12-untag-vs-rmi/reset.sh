#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
WORK="$(student_home)/workspace/02-12"
[[ -f "${WORK}/.id_a" ]] && podman rmi -f "$(cat "${WORK}/.id_a")" >/dev/null 2>&1 || true
[[ -f "${WORK}/.id_b" ]] && podman rmi -f "$(cat "${WORK}/.id_b")" >/dev/null 2>&1 || true
rm -rf "${WORK}"
