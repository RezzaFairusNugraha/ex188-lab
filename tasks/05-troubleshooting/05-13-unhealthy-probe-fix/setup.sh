#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-13"
podman rm -f portal-unhealthy >/dev/null 2>&1 || true

# Bug: probes port 80 instead of 8080!
podman run -d --name portal-unhealthy -p 8513:8080 \
    --health-cmd="wget -q -O /dev/null http://127.0.0.1:80/ || exit 1" \
    --health-interval=5s --health-retries=1 \
    quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null
sleep 1
podman healthcheck run portal-unhealthy >/dev/null 2>&1 || true
