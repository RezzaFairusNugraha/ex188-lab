#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-04"

assert_container_running 2 "legit-neighbor-0504"
check_cmd 3 "Rogue squatter container removed" "rogue-squatter-0504 still exists" \
    bash -c "! podman container exists rogue-squatter-0504"
assert_container_running 3 "prod-portal-0504"
assert_http_ok 2 "http://127.0.0.1:8504/" "nginx"

grade_finish
