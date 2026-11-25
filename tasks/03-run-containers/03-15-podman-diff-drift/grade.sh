#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-15"
WORK="$(student_home)/workspace/03-15"

assert_file_contains 5 "${WORK}/full-diff.txt" "^A /opt/legit-note\.txt$" "full-diff.txt captured initial podman diff"
assert_file_contains 5 "${WORK}/added-paths.txt" "^/opt/legit-note\.txt$" "added-paths.txt lists clean /path lines without 'A ' prefix"
check_cmd 5 "/tmp/unauthorized-dropper.sh removed from live container" \
    "/tmp/unauthorized-dropper.sh still appears in podman diff drift-watch" \
    bash -c "! podman diff drift-watch | grep -q 'unauthorized-dropper.sh'"

grade_finish
