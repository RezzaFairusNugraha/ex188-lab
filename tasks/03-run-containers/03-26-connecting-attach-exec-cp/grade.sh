#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-26"
WORK="$(student_home)/workspace/03-26"

assert_container_running 5 "console-repl"
assert_file_contains 5 "${WORK}/unlocked.token" "^TOKEN_ACTIVE_0326$" "PID 1 received UNLOCK command via attach and unlocked.token was copied to host"
check_cmd 5 "operator-ack.txt copied into console-repl:/tmp/operator-ack.txt" \
    "/tmp/operator-ack.txt inside console-repl missing or does not contain ACK_BY_STUDENT" \
    bash -c "podman exec console-repl cat /tmp/operator-ack.txt | grep -qx 'ACK_BY_STUDENT'"

grade_finish
