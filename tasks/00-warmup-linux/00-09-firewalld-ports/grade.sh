#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-09"
APP_TCP_PORT="${APP_TCP_PORT:-8448}"

assert_service_persistent 2 "system" "firewalld.service"
assert_firewall_port 3 "${APP_TCP_PORT}/tcp"
assert_firewall_port 3 "5514/udp"
check_cmd 2 "Stale port 9999/tcp removed from both runtime and permanent firewalld rules" \
    "9999/tcp is still open in runtime or permanent configuration" \
    bash -c '! run_privileged firewall-cmd --query-port=9999/tcp >/dev/null 2>&1 && ! run_privileged firewall-cmd --permanent --query-port=9999/tcp >/dev/null 2>&1'

grade_finish
