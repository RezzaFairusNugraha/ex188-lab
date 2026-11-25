#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-12"
SCRIPT="$(student_home)/workspace/05-12/deploy.sh"

assert_file_contains 4 "${SCRIPT}" "registry\.lab\.local:5000/inventory/catalog-svc:2\.1\.0" "deploy.sh updated with FQIN and tag 2.1.0"
assert_container_running 6 "catalog-svc"

grade_finish
