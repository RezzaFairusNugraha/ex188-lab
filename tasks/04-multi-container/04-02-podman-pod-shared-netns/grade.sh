#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-02"
POD_PORT="${POD_PORT:-8402}"

check_cmd 3 "Pod portal-pod exists and is Running" "pod portal-pod missing or not Running" \
    bash -c "[[ \"\$(podman pod inspect --format '{{.State}}' portal-pod 2>/dev/null)\" == 'Running' ]]"
assert_container_running 2 "pod-redis"
assert_container_running 2 "pod-web"
assert_http_ok 3 "http://127.0.0.1:${POD_PORT}/healthz" '"reachable": *true'

grade_finish
