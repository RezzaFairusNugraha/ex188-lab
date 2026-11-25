#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-19"

assert_file_exists 3 "/etc/containers/systemd/sys-gateway.container" "System Quadlet file exists"
assert_service_persistent 5 "system" "sys-gateway.service"
check_cmd 2 "Container sys-gateway exists in rootful podman storage" \
    "sys-gateway not running in rootful podman" \
    bash -c "[[ \"\$(run_privileged podman inspect --format '{{.State.Status}}' sys-gateway 2>/dev/null)\" == 'running' ]]"
assert_firewall_port 2 "8089/tcp"
assert_http_ok 3 "http://127.0.0.1:8089/" "nginx"

grade_finish
