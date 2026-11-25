#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-19"

assert_container_running 4 "do-not-touch-0519"
check_cmd 4 "Conflicting network stale-subnet-50 removed and orders-net created" \
    "stale-subnet-50 still exists or orders-net missing" \
    bash -c "! podman network exists stale-subnet-50 && podman network exists orders-net"
assert_container_running 3 "orders-cache"
assert_container_running 3 "orders-web"
assert_http_ok 6 "http://127.0.0.1:8519/healthz" '"reachable": *true'

grade_finish
