#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-13"
WORK="$(student_home)/workspace/02-13"

assert_file_contains 7 "${WORK}/catalog.json" '"repositories":.*finance/ledger-sync' "catalog.json contains /v2/_catalog JSON with finance/ledger-sync"
assert_file_contains 8 "${WORK}/ledger-tags.json" '"prod-signed"' "ledger-tags.json contains /v2/finance/ledger-sync/tags/list JSON with prod-signed"

grade_finish
