#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-16"
SUSER="$(student_user)"
QFILE="$(student_home)/.config/containers/systemd/critical-api.container"

assert_file_contains 5 "${QFILE}" "^WantedBy=default\.target$" "Quadlet [Install] uses WantedBy=default.target (not multi-user.target)"
assert_user_linger 5 "${SUSER}"
assert_service_persistent 5 "user" "critical-api.service"
assert_http_ok 5 "http://127.0.0.1:8516/" "nginx"

grade_finish
