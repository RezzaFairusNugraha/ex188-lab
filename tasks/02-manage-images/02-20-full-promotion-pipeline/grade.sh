#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-20"
AUTH="$(student_home)/.config/containers/auth.json"
OUT="$(student_home)/workspace/02-20/prod-tags.json"

assert_file_exists 3 "/etc/containers/registries.conf.d/70-dev.conf" "70-dev.conf exists"
assert_file_exists 3 "/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt" "CA installed for :5443"
assert_file_exists 3 "/etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt" "CA installed for :5444"
assert_file_exists 3 "${AUTH}" "Persistent auth.json exists"

assert_registry_image 3 "secure-reg.lab.local:5443/qa/payment-svc:1.0.0" "--cert-dir /etc/containers/certs.d/secure-reg.lab.local:5443" "QA image 1.0.0 verified in :5443"
assert_registry_image 3 "auth-reg.lab.local:5444/prod/payment-svc:1.0.0" "--cert-dir /etc/containers/certs.d/auth-reg.lab.local:5444 --creds student:redhat123" "Prod image 1.0.0 verified in :5444"
assert_file_contains 2 "${OUT}" '"1\.0\.0"' "prod-tags.json contains 1.0.0 and latest"

grade_finish
