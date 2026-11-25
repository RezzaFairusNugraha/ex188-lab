#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-26"
WORK="$(student_home)/workspace/03-26"
rm -rf "${WORK}"
mkdir -p "${WORK}"

podman rm -f console-repl >/dev/null 2>&1 || true
podman run -dit --name console-repl registry.access.redhat.com/ubi10/ubi-minimal:latest \
    sh -c 'echo "REPL-7741" > /etc/repl-passcode; while IFS= read -r line; do if [ "$line" = "UNLOCK REPL-7741" ]; then echo "TOKEN_ACTIVE_0326" > /tmp/repl-unlocked.token; echo "UNLOCKED"; fi; done; sleep 3600' >/dev/null
