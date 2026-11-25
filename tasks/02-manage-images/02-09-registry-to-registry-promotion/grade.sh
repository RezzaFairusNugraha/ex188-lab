#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-09"
REL_TAG="${REL_TAG:-1.4}"
TARGET="secure-reg.lab.local:5443/release/order-worker:${REL_TAG}"

assert_file_exists 3 "/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt" "CA trusted for secure-reg.lab.local:5443"
assert_image_exists 3 "${TARGET}"
check_cmd 3 "Temporary local staging tag registry.lab.local:5000/staging/order-worker:rc4 removed" \
    "staging tag rc4 still present in local podman images" \
    bash -c "! podman image exists registry.lab.local:5000/staging/order-worker:rc4"
assert_registry_image 6 "${TARGET}" "--cert-dir /etc/containers/certs.d/secure-reg.lab.local:5443" "Promoted image verified in secure-reg.lab.local:5443"

grade_finish
