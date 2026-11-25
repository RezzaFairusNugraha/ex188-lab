#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-18"

for c in vote-db vote-cache vote-api vote-ui; do
    assert_container_running 2 "${c}"
done
assert_http_ok 4 "http://127.0.0.1:8418/healthz" '"db_reachable": *true'
assert_http_ok 4 "http://127.0.0.1:8418/status" "EX188 Compose Poll"
check_cmd 4 "POST /vote increments tally persistently" \
    "POST http://127.0.0.1:8418/vote failed" \
    bash -c "curl -fsS -X POST http://127.0.0.1:8418/vote -d '{\"choice\":\"Podman Quadlet\"}' | grep -q '\"accepted\": *true'"

grade_finish
