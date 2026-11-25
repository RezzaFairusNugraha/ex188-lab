#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-18"
OUT="$(student_home)/workspace/02-18/classification.env"

assert_file_exists 2 "${OUT}" "classification.env exists"
assert_file_contains 6 "${OUT}" "^EXPORT_IMPORT_IMAGE=localhost/mystery-alpha:1\.0$" "Correctly identified export/import image (single flattened layer, stripped metadata)"
assert_file_contains 6 "${OUT}" "^COMMIT_IMAGE=localhost/mystery-beta:1\.0$" "Correctly identified commit image (extra layer with commit message)"
assert_file_contains 6 "${OUT}" "^SAVE_LOAD_IMAGE=localhost/mystery-gamma:1\.0$" "Correctly identified save/load image (full Containerfile step history preserved)"

grade_finish
