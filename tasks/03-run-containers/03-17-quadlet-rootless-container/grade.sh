#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-17"
HOST_PORT="${HOST_PORT:-8317}"
QUAD="$(student_home)/.config/containers/systemd/portal-quad.container"

assert_file_exists 3 "${QUAD}" "Quadlet file ${QUAD} exists"
assert_service_persistent 5 "user" "portal-quad.service"
assert_user_linger 2 "$(student_user)"
assert_container_running 2 "portal-quad"
assert_http_ok 3 "http://127.0.0.1:${HOST_PORT}/" "nginx"

grade_finish
