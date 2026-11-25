#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-04"
podman rm -f prod-portal-0504 rogue-squatter-0504 legit-neighbor-0504 >/dev/null 2>&1 || true

podman run -d --name legit-neighbor-0504 -p 8599:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null
podman run -d --name rogue-squatter-0504 -p 8504:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null
podman create --name prod-portal-0504 -p 8504:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null
