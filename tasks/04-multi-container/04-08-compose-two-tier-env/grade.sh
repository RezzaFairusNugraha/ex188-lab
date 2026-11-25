#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-08"
WORK="$(student_home)/workspace/04-08"

assert_file_exists 2 "${WORK}/.env" ".env exists"
assert_file_contains 3 "${WORK}/compose.yaml" '\$\{PUBLISHED_PORT\}' "compose.yaml interpolates \${PUBLISHED_PORT}"
assert_container_running 2 "compose-db"
assert_container_running 2 "compose-web"
assert_container_mount 2 "compose-db" "/var/lib/pgsql/data" "rw"
assert_http_ok 4 "http://127.0.0.1:8408/healthz" '"reachable": *true'

grade_finish
