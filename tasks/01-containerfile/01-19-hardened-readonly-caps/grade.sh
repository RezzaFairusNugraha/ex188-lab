#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-19"

assert_container_running 3 "hardened-web"
check_cmd 3 "Root filesystem is read-only (HostConfig.ReadonlyRootfs == true)" \
    "ReadonlyRootfs is false on hardened-web" \
    bash -c "[[ \"\$(podman inspect --format '{{.HostConfig.ReadonlyRootfs}}' hardened-web)\" == 'true' ]]"
check_cmd 3 "Effective capabilities set is empty (0000000000000000)" \
    "container still retains Linux capabilities (did you pass --cap-drop=ALL?)" \
    bash -c "podman exec hardened-web awk '/^CapEff:/ {print \$2}' /proc/1/status | grep -qx '0000000000000000'"
check_cmd 3 "NoNewPrivileges is enabled" \
    "NoNewPrivs is not 1 inside /proc/1/status" \
    bash -c "podman exec hardened-web awk '/^NoNewPrivs:/ {print \$2}' /proc/1/status | grep -qx '1'"
assert_http_ok 3 "http://127.0.0.1:8099/healthz" '"status": *"ok"'

grade_finish
