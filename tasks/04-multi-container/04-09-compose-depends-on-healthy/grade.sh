#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-09"
WORK="$(student_home)/workspace/04-09"

assert_file_contains 4 "${WORK}/compose.yaml" "service_healthy" "compose.yaml uses condition: service_healthy"
podman healthcheck run hc-cache >/dev/null 2>&1 || true
assert_container_healthy 4 "hc-cache"
assert_container_running 3 "hc-web"
assert_http_ok 4 "http://127.0.0.1:8409/healthz" '"reachable": *true'

grade_finish
