#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-20"
REP="$(student_home)/workspace/05-20/oom-report.env"

assert_file_contains 4 "${REP}" "^OOMKILLED=true$" "oom-report.env confirms OOMKILLED=true"
assert_file_contains 4 "${REP}" "^OLD_MEMORY_BYTES=12582912$" "oom-report.env records initial 12m limit (12582912 bytes)"
assert_container_running 6 "batch-mem-0520"
check_cmd 6 "batch-mem-0520 runs with 128m memory limit and logs BATCH_READY" \
    "Memory limit != 134217728 or BATCH_READY missing from logs" \
    bash -c "[[ \"\$(podman inspect --format '{{.HostConfig.Memory}}' batch-mem-0520)\" == '134217728' ]] && podman logs batch-mem-0520 | grep -q 'BATCH_READY'"

grade_finish
