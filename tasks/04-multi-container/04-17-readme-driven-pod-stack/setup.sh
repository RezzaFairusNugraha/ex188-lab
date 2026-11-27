#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-17"
seed_port "04-17" HOST_PORT 8417 18710 18799

WORK="$(student_home)/workspace/04-17"
podman rm -f acme-app acme-redis acme-pg >/dev/null 2>&1 || true
podman network rm -f readme-net >/dev/null 2>&1 || true
podman volume rm -f acme-notes-vol acme-db-vol >/dev/null 2>&1 || true
podman secret rm acme_sign_key >/dev/null 2>&1 || true
podman rmi -f localhost/acme-full:1.0 >/dev/null 2>&1 || true
rm -rf "${WORK}"
stage_vendor_app webapp-flask "${WORK}/build"
