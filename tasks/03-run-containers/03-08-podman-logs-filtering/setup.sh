#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-08"
WORK="$(student_home)/workspace/03-08"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f log-emitter >/dev/null 2>&1 || true

podman run -d --name log-emitter registry.access.redhat.com/ubi10/ubi-minimal:latest \
    sh -c 'for i in $(seq -w 1 20); do echo "LINE-${i}"; done; echo "ALERT-A" >&2; echo "ALERT-B" >&2; echo "ALERT-C" >&2; sleep 3600' >/dev/null
sleep 1
