#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-04"
CERT="/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt"

assert_file_exists 4 "${CERT}" "Per-registry CA certificate installed at ${CERT}"
check_cmd 3 "secure-reg.lab.local:5443 is NOT marked insecure in registries.conf*" \
    "found prohibited insecure = true for secure-reg.lab.local:5443" \
    bash -c "! grep -rn 'secure-reg.lab.local:5443' /etc/containers/registries.conf* ~/.config/containers/registries.conf* 2>/dev/null | grep -q 'insecure'"
check_cmd 8 "podman pull --tls-verify=true secure-reg.lab.local:5443/qa/verified-ubi:1.0 succeeds" \
    "TLS-verified pull failed from secure-reg.lab.local:5443/qa/verified-ubi:1.0" \
    podman pull --tls-verify=true secure-reg.lab.local:5443/qa/verified-ubi:1.0

grade_finish
