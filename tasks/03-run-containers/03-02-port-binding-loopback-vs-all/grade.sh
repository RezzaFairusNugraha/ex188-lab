#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-02"
PUB_PORT="${PUB_PORT:-18082}"
WORK="$(student_home)/workspace/03-02"

assert_container_running 2 "admin-local"
assert_container_port 3 "admin-local" "8080/tcp" "18081" "127.0.0.1"
assert_container_running 2 "public-front"
assert_container_port 2 "public-front" "8080/tcp" "${PUB_PORT}" "0.0.0.0"
assert_file_contains 1 "${WORK}/admin-port.txt" "127\.0\.0\.1:18081" "admin-port.txt records loopback binding"

grade_finish
