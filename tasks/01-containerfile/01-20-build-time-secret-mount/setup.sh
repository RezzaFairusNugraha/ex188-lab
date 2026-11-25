#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-20"
WORK="$(student_home)/workspace/01-20"
rm -rf "${WORK}"
mkdir -p "${WORK}"
printf 'Tok_PrivateBuildRepo_994812_DO_NOT_BAKE\n' > "${WORK}/repo-credential.txt"
chmod 0600 "${WORK}/repo-credential.txt"
podman rmi -f localhost/secret-safe:1.0 >/dev/null 2>&1 || true
