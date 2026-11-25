#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f prod-keeper junk-crash-1 junk-crash-2 >/dev/null 2>&1 || true
podman volume rm -f prod-keeper-vol orphan-vol-1 orphan-vol-2 >/dev/null 2>&1 || true
podman rmi -f localhost/bloated-junk:old >/dev/null 2>&1 || true
