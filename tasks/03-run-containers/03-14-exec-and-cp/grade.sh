#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-14"
WORK="$(student_home)/workspace/03-14"

assert_file_contains 4 "${WORK}/diag-report.txt" "^DIAG_OK_0314$" "Copied /tmp/diag-report.txt from container to host"
assert_http_ok 6 "http://127.0.0.1:8314/" "Updated Live via podman cp"

grade_finish
