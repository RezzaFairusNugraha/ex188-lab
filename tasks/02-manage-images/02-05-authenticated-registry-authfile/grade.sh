#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-05"
CERT="/etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt"
AUTH="$(student_home)/.config/containers/auth.json"

assert_file_exists 3 "${CERT}" "CA certificate installed at ${CERT}"
assert_file_exists 4 "${AUTH}" "Persistent auth.json created at ${AUTH}"
assert_file_contains 3 "${AUTH}" "auth-reg\.lab\.local:5444" "auth.json records credentials for auth-reg.lab.local:5444"
check_cmd 5 "Authenticated TLS pull using persistent auth.json succeeds" \
    "podman pull with --authfile failed against auth-reg.lab.local:5444/prod/core-ubi:1.0" \
    podman pull --tls-verify=true --authfile "${AUTH}" auth-reg.lab.local:5444/prod/core-ubi:1.0

grade_finish
