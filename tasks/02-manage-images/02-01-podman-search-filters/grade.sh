#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-01"
OUT="$(student_home)/workspace/02-01/repos.txt"

assert_file_exists 2 "${OUT}" "Output file ${OUT} exists"
assert_file_contains 3 "${OUT}" "^registry\.lab\.local:5000/ops/httpd-edge$" "Contains ops/httpd-edge"
assert_file_contains 3 "${OUT}" "^registry\.lab\.local:5000/ops/metrics-collector$" "Contains ops/metrics-collector"
check_cmd 2 "No table header ('NAME') included in repos.txt" \
    "repos.txt contains table headers instead of pure --format '{{.Name}}' lines" \
    bash -c "! grep -qi '^NAME[[:space:]]' '${OUT}' && grep -qx 'registry.lab.local:5000/ops/redis-cache' '${OUT}'"

grade_finish
