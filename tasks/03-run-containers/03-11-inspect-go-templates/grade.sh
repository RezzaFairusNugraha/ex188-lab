#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-11"
OUT="$(student_home)/workspace/03-11/summary.env"
EXP_IP="$(podman inspect --format '{{(index .NetworkSettings.Networks "net-0311").IPAddress}}' inspect-live)"
EXP_PID="$(podman inspect --format '{{.State.Pid}}' inspect-live)"
EXP_START="$(podman inspect --format '{{.State.StartedAt}}' inspect-crashed)"

assert_file_exists 1 "${OUT}" "summary.env exists"
assert_file_contains 4 "${OUT}" "^LIVE_IP=${EXP_IP}$" "LIVE_IP matches ${EXP_IP}"
assert_file_contains 3 "${OUT}" "^LIVE_PID=${EXP_PID}$" "LIVE_PID matches ${EXP_PID}"
assert_file_contains 4 "${OUT}" "^CRASH_EXIT_CODE=42$" "CRASH_EXIT_CODE matches 42"
assert_file_contains 3 "${OUT}" "^CRASH_STARTED_AT=${EXP_START}$" "CRASH_STARTED_AT matches State.StartedAt"

grade_finish
