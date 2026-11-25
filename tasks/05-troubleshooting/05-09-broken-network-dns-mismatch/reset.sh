#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f broken-app-0509 broken-db-0509 >/dev/null 2>&1 || true
podman network rm -f appnet-0509 >/dev/null 2>&1 || true
podman volume rm -f pgvol-0509 >/dev/null 2>&1 || true
podman rmi -f localhost/ts-web-0509:1.0 >/dev/null 2>&1 || true
