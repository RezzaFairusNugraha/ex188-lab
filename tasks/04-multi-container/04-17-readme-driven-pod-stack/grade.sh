#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-17"
HOST_PORT="${HOST_PORT:-8417}"

assert_container_running 2 "acme-redis"
assert_container_running 2 "acme-pg"
assert_container_running 3 "acme-app"
assert_http_ok 4 "http://127.0.0.1:${HOST_PORT}/healthz" '"storage": *"writable"'
assert_http_ok 4 "http://127.0.0.1:${HOST_PORT}/" '"secret_source": *"file"'

grade_finish
