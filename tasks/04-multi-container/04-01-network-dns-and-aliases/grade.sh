#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-01"

check_cmd 2 "Network app-mesh exists" "network app-mesh missing" podman network exists app-mesh
assert_container_running 2 "cache-primary"
assert_container_running 2 "web-client"
assert_http_ok 4 "http://127.0.0.1:8401/healthz" '"reachable": *true'

grade_finish
