#!/usr/bin/env bash
set -uo pipefail
export LAB_SKIP_PROGRESS=1
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/grade.sh"
grade_init "mock-05-reboot"
assert_user_linger 5 "$(student_user)"
assert_service_persistent 10 "system" "m05-sys-metrics.service"
assert_service_persistent 10 "user" "m05-edge.service"
assert_service_persistent 10 "user" "m05-web.service"
assert_service_persistent 10 "user" "m05-pod-pod.service"
assert_service_persistent 10 "user" "m05-ts-persist.service"
assert_firewall_port 5 "18502/tcp"
assert_http_ok 5 "http://127.0.0.1:18502/entries" m05-persist
grade_finish
