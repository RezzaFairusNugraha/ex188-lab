#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-20"
registry_start_all
WORK="$(student_home)/workspace/02-20"
rm -rf "${WORK}"
mkdir -p "${WORK}"
rm -f "$(student_home)/.config/containers/registries.conf" "$(student_home)/.config/containers/auth.json"
run_privileged rm -f /etc/containers/registries.conf.d/70-dev.conf
run_privileged rm -rf "/etc/containers/certs.d/${REG_TLS_HOST}" "/etc/containers/certs.d/${REG_AUTH_HOST}"

podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_INSECURE_HOST}/dev/payment-svc:0.9-rc2"
podman push --tls-verify=false "${REG_INSECURE_HOST}/dev/payment-svc:0.9-rc2" >/dev/null
podman rmi "${REG_INSECURE_HOST}/dev/payment-svc:0.9-rc2" >/dev/null 2>&1 || true
