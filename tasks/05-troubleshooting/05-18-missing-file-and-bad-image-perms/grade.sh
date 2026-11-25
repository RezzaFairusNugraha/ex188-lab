#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-18"

assert_container_running 5 "portal-0518"
assert_http_ok 5 "http://127.0.0.1:8518/healthz" "OK"
assert_http_ok 5 "http://127.0.0.1:8518/" "Cloud-Native Operations Portal"

grade_finish
