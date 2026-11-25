#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-05"

assert_container_running 3 "metrics-broken-port"
assert_http_ok 7 "http://127.0.0.1:9505/healthz" '"service": *"ts-0505"'

grade_finish
