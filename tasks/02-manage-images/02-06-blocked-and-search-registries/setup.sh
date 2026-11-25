#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-06"
registry_start_all
rm -f "$(student_home)/.config/containers/registries.conf"
podman rmi -f localhost/mini-tool:verified "${REG_TLS_HOST}/approved/mini-tool:1.0" >/dev/null 2>&1 || true

# Seed image into :5443
run_privileged mkdir -p "/etc/containers/certs.d/${REG_TLS_HOST}"
run_privileged install -m 0644 "${LAB_CERTS_DIR}/ca.crt" "/etc/containers/certs.d/${REG_TLS_HOST}/ca.crt"
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_TLS_HOST}/approved/mini-tool:1.0"
podman push --remove-signatures "${REG_TLS_HOST}/approved/mini-tool:1.0" >/dev/null
podman rmi "${REG_TLS_HOST}/approved/mini-tool:1.0" >/dev/null 2>&1 || true
run_privileged rm -rf "/etc/containers/certs.d/${REG_TLS_HOST}"
