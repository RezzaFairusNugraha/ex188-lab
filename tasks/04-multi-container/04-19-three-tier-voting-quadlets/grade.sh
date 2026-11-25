#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-19"

assert_service_persistent 5 "user" "qv-ui.service"
for c in qv-db qv-cache qv-api qv-ui; do
    assert_container_running 2 "${c}"
done
assert_user_linger 2 "$(student_user)"
assert_http_ok 5 "http://127.0.0.1:8419/healthz" '"secret_loaded": *true'

grade_finish
