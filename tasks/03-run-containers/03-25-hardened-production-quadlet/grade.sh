#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-25"
QUAD="$(student_home)/.config/containers/systemd/prod-metrics.container"

assert_file_contains 3 "${QUAD}" "^Image=secure-reg\.lab\.local:5443/prod/metrics-agent@sha256:" "Quadlet pins Image by @sha256 digest"
assert_service_persistent 5 "user" "prod-metrics.service"
check_cmd 4 "ReadonlyRootfs==true, CapEff==0, and NoNewPrivs==1 on prod-metrics" \
    "hardening settings missing on live prod-metrics container" \
    bash -c "[[ \"\$(podman inspect --format '{{.HostConfig.ReadonlyRootfs}}' prod-metrics)\" == 'true' ]] && podman exec prod-metrics awk '/^CapEff:/ {print \$2}' /proc/1/status | grep -qx '0000000000000000' && podman exec prod-metrics awk '/^NoNewPrivs:/ {print \$2}' /proc/1/status | grep -qx '1'"
assert_firewall_port 4 "9325/tcp"
assert_http_ok 4 "http://127.0.0.1:9325/metrics" 'ex188_up\{service="prod-node-01"\} 1'

grade_finish
