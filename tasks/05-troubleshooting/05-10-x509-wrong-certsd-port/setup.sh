#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "05-10"
registry_start_all
podman rm -f agent-0510 >/dev/null 2>&1 || true

# Seed image first
run_privileged mkdir -p "/etc/containers/certs.d/${REG_TLS_HOST}"
run_privileged install -m 0644 "${LAB_CERTS_DIR}/ca.crt" "/etc/containers/certs.d/${REG_TLS_HOST}/ca.crt"
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_TLS_HOST}/ops/agent-0510:1.0"
podman push --remove-signatures "${REG_TLS_HOST}/ops/agent-0510:1.0" >/dev/null
podman rmi "${REG_TLS_HOST}/ops/agent-0510:1.0" >/dev/null 2>&1 || true

# Introduce the bug: wrong folder name missing :5443 AND restrictive 0600 mode!
run_privileged rm -rf "/etc/containers/certs.d/${REG_TLS_HOST}" /etc/containers/certs.d/secure-reg.lab.local
run_privileged mkdir -p /etc/containers/certs.d/secure-reg.lab.local
run_privileged install -m 0600 "${LAB_CERTS_DIR}/ca.crt" /etc/containers/certs.d/secure-reg.lab.local/ca.crt
