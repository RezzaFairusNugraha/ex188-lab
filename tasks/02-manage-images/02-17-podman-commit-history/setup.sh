#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "02-17"
podman rm -f hotfix-sandbox >/dev/null 2>&1 || true
podman rmi -f localhost/hotfix-snapshot:1.1 >/dev/null 2>&1 || true

podman run -d --name hotfix-sandbox registry.access.redhat.com/ubi10/ubi-minimal:latest \
    sh -c 'echo "INITIAL=true" > /etc/hotfix.conf && sleep 3600' >/dev/null
sleep 1
