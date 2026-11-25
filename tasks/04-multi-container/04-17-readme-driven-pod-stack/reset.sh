#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f acme-app acme-redis acme-pg >/dev/null 2>&1 || true
podman network rm -f readme-net >/dev/null 2>&1 || true
podman volume rm -f acme-notes-vol acme-db-vol >/dev/null 2>&1 || true
podman secret rm acme_sign_key >/dev/null 2>&1 || true
podman rmi -f localhost/acme-full:1.0 >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/04-17"
