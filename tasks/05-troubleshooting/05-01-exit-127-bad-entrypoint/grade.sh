#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-01"
WORK="$(student_home)/workspace/05-01"

assert_file_contains 3 "${WORK}/initial-exit.txt" "^127$" "Recorded exit code 127 in initial-exit.txt"
assert_container_running 3 "broken-web-0501"
assert_http_ok 4 "http://127.0.0.1:8501/healthz" '"status": *"ok"'

grade_finish
