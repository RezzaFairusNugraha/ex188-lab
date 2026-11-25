#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-15"
QDIR="$(student_home)/.config/containers/systemd"

assert_file_exists 3 "${QDIR}/telemetry-stack.pod" "telemetry-stack.pod exists"
assert_service_persistent 5 "user" "telemetry-stack-pod.service"
assert_container_running 3 "telemetry-redis"
assert_container_running 3 "telemetry-web"
assert_user_linger 2 "$(student_user)"
assert_http_ok 4 "http://127.0.0.1:8415/healthz" '"reachable": *true'

grade_finish
