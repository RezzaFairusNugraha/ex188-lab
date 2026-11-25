#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "02-11"
registry_start_all
TMP_B="$(mktemp -d)"
printf 'FROM registry.access.redhat.com/ubi10/ubi-minimal:latest\nENV PORTAL_BUILD=ci\n' > "${TMP_B}/Containerfile"
podman build -q -t localhost/portal-build:ci "${TMP_B}" >/dev/null
rm -rf "${TMP_B}"
