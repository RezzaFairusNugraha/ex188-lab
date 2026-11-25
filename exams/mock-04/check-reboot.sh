#!/usr/bin/env bash
set -uo pipefail
export LAB_SKIP_PROGRESS=1
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/grade.sh"
grade_init "mock-04-reboot"
assert_user_linger 5 "$(student_user)"
assert_service_persistent 10 "user" "m04-q-db.service"
assert_service_persistent 10 "user" "m04-q-api.service"
assert_service_persistent 10 "user" "m04-q-ui.service"
assert_service_persistent 10 "user" "m04-ts-lost.service"
assert_firewall_port 5 "18402/tcp"
assert_http_ok 5 "http://127.0.0.1:18402/healthz" ok
grade_finish
