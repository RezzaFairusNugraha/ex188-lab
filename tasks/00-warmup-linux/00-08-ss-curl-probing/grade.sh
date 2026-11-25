#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-08"
PROBE_PORT="${PROBE_PORT:-19620}"
WORK="$(student_home)/workspace/00-08"

assert_file_contains 5 "${WORK}/probe-port.txt" "^${PROBE_PORT}$" "Correct telemetry-probe port (${PROBE_PORT}) saved to probe-port.txt"
assert_file_contains 5 "${WORK}/status.json" '"service": *"telemetry-probe"' "JSON payload from /status saved to status.json"

grade_finish
