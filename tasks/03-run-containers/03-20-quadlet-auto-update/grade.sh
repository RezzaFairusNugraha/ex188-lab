#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-20"
QUAD="$(student_home)/.config/containers/systemd/autoweb.container"

assert_file_contains 4 "${QUAD}" "^AutoUpdate=registry$" "Quadlet specifies AutoUpdate=registry"
assert_service_persistent 5 "user" "autoweb.service"
check_cmd 5 "Container carries io.containers.autoupdate=registry label" \
    "autoweb container missing io.containers.autoupdate=registry label" \
    bash -c "[[ \"\$(podman inspect --format '{{index .Config.Labels \"io.containers.autoupdate\"}}' systemd-autoweb 2>/dev/null || podman inspect --format '{{index .Config.Labels \"io.containers.autoupdate\"}}' autoweb 2>/dev/null)\" == 'registry' ]]"
assert_http_ok 6 "http://127.0.0.1:8320/" "REL-V2"

grade_finish
