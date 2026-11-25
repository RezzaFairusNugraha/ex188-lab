#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-18"
QDIR="$(student_home)/.config/containers/systemd"

assert_file_exists 3 "${QDIR}/notes-store.volume" "Quadlet volume file notes-store.volume exists"
assert_file_exists 3 "${QDIR}/notes-quad.container" "Quadlet container file notes-quad.container exists"
assert_service_persistent 4 "user" "notes-quad.service"
assert_http_ok 5 "http://127.0.0.1:8318/entries" "quadlet-vol-ok"

grade_finish
