#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-21"
HOST_PORT="${HOST_PORT:-8321}"

assert_image_user 3 "localhost/acme-status:1.0" "1001"
assert_service_persistent 5 "user" "acme-status.service"
assert_user_linger 2 "$(student_user)"
assert_http_ok 5 "http://127.0.0.1:${HOST_PORT}/" "Quadlet Operations Hub"

grade_finish
