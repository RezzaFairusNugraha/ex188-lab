#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-14"
QDIR="$(student_home)/.config/containers/systemd"

assert_file_exists 2 "${QDIR}/tier-net.network" "tier-net.network exists"
assert_file_exists 2 "${QDIR}/tier-pg.volume" "tier-pg.volume exists"
assert_service_persistent 3 "user" "q-db.service"
assert_service_persistent 4 "user" "q-web.service"
assert_http_ok 4 "http://127.0.0.1:8414/healthz" '"reachable": *true'

grade_finish
