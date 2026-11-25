#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-09"

assert_container_running 3 "broken-db-0509"
assert_container_running 3 "broken-app-0509"
check_cmd 4 "Both containers are attached to appnet-0509" \
    "one or both containers missing from network appnet-0509" \
    bash -c "podman inspect --format '{{json .NetworkSettings.Networks}}' broken-app-0509 | grep -q 'appnet-0509' && podman inspect --format '{{json .NetworkSettings.Networks}}' broken-db-0509 | grep -q 'appnet-0509'"
assert_http_ok 5 "http://127.0.0.1:8509/healthz" '"reachable": *true'

grade_finish
