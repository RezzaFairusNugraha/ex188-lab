#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-13"
registry_start_all
WORK="$(student_home)/workspace/02-13"
rm -rf "${WORK}"
mkdir -p "${WORK}"

AUTH_TMP="$(mktemp)"
run_privileged mkdir -p "/etc/containers/certs.d/${REG_AUTH_HOST}"
run_privileged install -m 0644 "${LAB_CERTS_DIR}/ca.crt" "/etc/containers/certs.d/${REG_AUTH_HOST}/ca.crt"
podman login --authfile "${AUTH_TMP}" -u student -p redhat123 "${REG_AUTH_HOST}" >/dev/null
for tg in 3.1.0 3.1.1 prod-signed; do
    podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_AUTH_HOST}/finance/ledger-sync:${tg}"
    podman push --authfile "${AUTH_TMP}" "${REG_AUTH_HOST}/finance/ledger-sync:${tg}" >/dev/null
    podman rmi "${REG_AUTH_HOST}/finance/ledger-sync:${tg}" >/dev/null 2>&1 || true
done
rm -f "${AUTH_TMP}"
