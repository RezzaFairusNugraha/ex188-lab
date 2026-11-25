#!/usr/bin/env bash
set -uo pipefail
export LAB_SKIP_PROGRESS=1
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/grade.sh"
grade_init "mock-03-reboot"
assert_user_linger 5 "$(student_user)"
assert_service_persistent 10 "user" "m03-kube.service"
assert_service_persistent 10 "user" "m03-app-pod.service"
assert_service_persistent 10 "user" "m03-api.service"
assert_firewall_port 5 "18301/tcp"
assert_http_ok 5 "http://127.0.0.1:18302/healthz" ok
grade_finish
