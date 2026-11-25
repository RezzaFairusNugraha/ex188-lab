#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-09"
WORK="$(student_home)/workspace/03-09"

assert_container_running 4 "journal-auditor"
check_cmd 5 "Container LogConfig.Type equals journald" \
    "LogConfig.Type is not journald on journal-auditor" \
    bash -c "[[ \"\$(podman inspect --format '{{.HostConfig.LogConfig.Type}}' journal-auditor)\" == 'journald' ]]"
assert_file_contains 6 "${WORK}/journal-extract.log" "AUDIT_EVENT_90210_READY" "journal-extract.log captured AUDIT_EVENT_90210_READY from journald"

grade_finish
