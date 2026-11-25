#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-06"

assert_container_running 3 "webapp-ext-0506"
assert_container_port 4 "webapp-ext-0506" "8080/tcp" "8506" "0.0.0.0"
assert_firewall_port 4 "8506/tcp"
assert_http_ok 4 "http://127.0.0.1:8506/healthz" '"status": *"ok"'

grade_finish
