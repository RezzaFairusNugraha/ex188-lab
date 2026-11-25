#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-10"
CERT="/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt"

assert_file_exists 5 "${CERT}" "Certificate placed at exact host:port path ${CERT}"
check_cmd 5 "podman pull --tls-verify=true secure-reg.lab.local:5443/ops/agent-0510:1.0 succeeds" \
    "pull with --tls-verify=true failed (check file mode 0644 on ca.crt!)" \
    podman pull --tls-verify=true secure-reg.lab.local:5443/ops/agent-0510:1.0
assert_container_running 5 "agent-0510"

grade_finish
