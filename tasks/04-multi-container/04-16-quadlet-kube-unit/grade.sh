#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-16"
QFILE="$(student_home)/.config/containers/systemd/qkube-app.kube"

assert_file_exists 4 "${QFILE}" "Quadlet qkube-app.kube exists"
assert_file_contains 3 "${QFILE}" "^ConfigMap=" "qkube-app.kube specifies ConfigMap="
assert_service_persistent 5 "user" "qkube-app.service"
assert_http_ok 4 "http://127.0.0.1:8416/healthz" '"reachable": *true'
assert_http_ok 4 "http://127.0.0.1:8416/" "Quadlet Kube Unit"

grade_finish
