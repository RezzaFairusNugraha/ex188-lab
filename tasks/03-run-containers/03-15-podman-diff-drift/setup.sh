#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-15"
WORK="$(student_home)/workspace/03-15"
rm -rf "${WORK}"
mkdir -p "${WORK}"
podman rm -f drift-watch >/dev/null 2>&1 || true

podman run -d --name drift-watch registry.access.redhat.com/ubi10/ubi-minimal:latest \
    sh -c 'echo "# drift" >> /etc/hosts; echo "keep" > /opt/legit-note.txt; echo "bad" > /tmp/unauthorized-dropper.sh; sleep 3600' >/dev/null
sleep 1
