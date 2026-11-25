#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-03"

assert_container_running 3 "billing-api-0503"
assert_container_env 3 "billing-api-0503" "AUTH_REQUIRED" "true"
assert_http_ok 4 "http://127.0.0.1:3503/api/v1/info" '"auth_configured": *true'

grade_finish
