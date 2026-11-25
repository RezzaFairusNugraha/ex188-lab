#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-19"
WORK="$(student_home)/workspace/02-19"

assert_image_exists 5 "localhost/from-dir:1.0"
assert_image_exists 5 "localhost/from-oci:1.0"
assert_file_exists 5 "${WORK}/exported-dir/manifest.json" "exported-dir/manifest.json created via dir: transport"

grade_finish
