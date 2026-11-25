#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-07"
registry_start_all
run_privileged rm -f /etc/containers/registries.conf.d/60-corp-mirror.conf
rm -f "$(student_home)/.config/containers/registries.conf"
podman rmi -f upstream-hub.corp.example/platform/agent:2.1 "${REG_TLS_HOST}/platform/agent:2.1" >/dev/null 2>&1 || true

run_privileged mkdir -p "/etc/containers/certs.d/${REG_TLS_HOST}"
run_privileged install -m 0644 "${LAB_CERTS_DIR}/ca.crt" "/etc/containers/certs.d/${REG_TLS_HOST}/ca.crt"
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_TLS_HOST}/platform/agent:2.1"
podman push --remove-signatures "${REG_TLS_HOST}/platform/agent:2.1" >/dev/null
podman rmi "${REG_TLS_HOST}/platform/agent:2.1" >/dev/null 2>&1 || true
run_privileged rm -rf "/etc/containers/certs.d/${REG_TLS_HOST}"
