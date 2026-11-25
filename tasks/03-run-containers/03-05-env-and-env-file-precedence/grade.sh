#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-05"
WORK="$(student_home)/workspace/03-05"

assert_file_contains 2 "${WORK}/base.env" "^APP_ENV=staging$" "base.env preserved unmodified"
assert_container_running 2 "env-precedence"
assert_container_env 3 "env-precedence" "LOG_LEVEL" "warn"
assert_http_ok 3 "http://127.0.0.1:8305/" '"env": *"production"'

grade_finish
