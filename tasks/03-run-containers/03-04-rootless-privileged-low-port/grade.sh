#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-04"
SYSCTL_F="/etc/sysctl.d/90-ex188-lowports.conf"

assert_file_contains 4 "${SYSCTL_F}" "^net\.ipv4\.ip_unprivileged_port_start *= *800$" "Persistent sysctl file sets ip_unprivileged_port_start = 800"
check_cmd 4 "Live kernel net.ipv4.ip_unprivileged_port_start <= 800" \
    "live sysctl value is still > 800 (did you run sudo sysctl --system?)" \
    bash -c "(( \$(sysctl -n net.ipv4.ip_unprivileged_port_start) <= 800 ))"
assert_container_running 4 "lowport-web"
assert_container_port 3 "lowport-web" "8080/tcp" "808"
assert_firewall_port 2 "808/tcp"
assert_http_ok 3 "http://127.0.0.1:808/" "nginx"

grade_finish
