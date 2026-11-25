#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-03"
EXT_PORT="${EXT_PORT:-8883}"

assert_container_running 3 "edge-portal"
assert_container_port 3 "edge-portal" "8080/tcp" "${EXT_PORT}" "0.0.0.0"
assert_container_mount 2 "edge-portal" "/usr/share/nginx/html" "ro"
assert_firewall_port 4 "${EXT_PORT}/tcp"
assert_http_ok 3 "http://127.0.0.1:${EXT_PORT}/" "Cloud-Native Operations Portal"

grade_finish
