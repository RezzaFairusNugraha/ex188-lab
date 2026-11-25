#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-10"
HOST_PORT="${HOST_PORT:-8091}"
WORK="$(student_home)/workspace/01-10"

assert_image_exists 2 "localhost/portal-expose:1.0"
assert_container_running 2 "portal-explicit"
assert_container_port 2 "portal-explicit" "8080/tcp" "${HOST_PORT}"
assert_http_ok 2 "http://127.0.0.1:${HOST_PORT}/healthz" "OK"

AUTO_ACTUAL="$(podman port portal-auto 8080/tcp 2>/dev/null | head -n1 | awk -F: '{print $NF}')"
if [[ -n "${AUTO_ACTUAL}" ]] && [[ -f "${WORK}/auto-port.txt" ]] && [[ "$(tr -d '[:space:]' < "${WORK}/auto-port.txt")" == "${AUTO_ACTUAL}" ]]; then
    pass_check 2 "portal-auto runs with -P and auto-port.txt matches assigned port (${AUTO_ACTUAL})"
else
    fail_check 2 "portal-auto -P port recording" "expected auto-port.txt to match podman port (${AUTO_ACTUAL:-not running})"
fi

grade_finish
