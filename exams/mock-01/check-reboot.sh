#!/usr/bin/env bash
set -uo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/grade.sh"

grade_init "mock-01-reboot"
assert_user_linger 5 "$(student_user)"
assert_service_persistent 10 "user" "m01-portal.service"
assert_service_persistent 10 "user" "m01-metrics.service"
assert_service_persistent 10 "user" "m01-app-pod.service"
assert_service_persistent 10 "user" "m01-lost.service"
assert_firewall_port 5 "18101/tcp"
assert_http_ok 5 "http://127.0.0.1:18103/entries" "mock01-note-ok"
grade_finish
