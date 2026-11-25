#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-13"
WORK="$(student_home)/workspace/03-13"

assert_file_contains 5 "${WORK}/top-map.txt" "HUSER.*HPID" "top-map.txt includes USER/HUSER/PID/HPID columns from podman top"
assert_file_contains 5 "${WORK}/stats.txt" "^metrics-target " "stats.txt records single snapshot for metrics-target"

grade_finish
