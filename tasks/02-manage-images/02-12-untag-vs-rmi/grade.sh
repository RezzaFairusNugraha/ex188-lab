#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-12"
WORK="$(student_home)/workspace/02-12"
ID_A="$(cat "${WORK}/.id_a")"
ID_B="$(cat "${WORK}/.id_b")"

assert_file_exists 2 "${WORK}/kept-id.txt" "kept-id.txt exists"
check_cmd 4 "Image A has zero tags left, yet Image ID still exists in local storage" \
    "Image A was deleted instead of untagged, or tags still remain" \
    bash -c "! podman image exists localhost/keep-layers:1.0 && ! podman image exists localhost/keep-layers:temp && podman image exists '${ID_A}'"
check_cmd 4 "Image B (${ID_B:0:12}) completely removed from local storage" \
    "Image B still exists in local storage" \
    bash -c "! podman image exists '${ID_B}'"

grade_finish
