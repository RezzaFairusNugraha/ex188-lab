#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-12"
WORK="$(student_home)/workspace/01-12"

assert_file_contains 3 "${WORK}/Containerfile" "^ARG UBI_VARIANT" "ARG UBI_VARIANT declared in Containerfile"
assert_image_exists 2 "localhost/scoped-ubi:1.0"
check_cmd 4 "/etc/selected-variant inside image equals 'ubi-minimal' (not empty!)" \
    "/etc/selected-variant is empty — forgot to re-declare ARG UBI_VARIANT after FROM!" \
    bash -c "[[ \"\$(podman run --rm localhost/scoped-ubi:1.0 cat /etc/selected-variant)\" == 'ubi-minimal' ]]"
assert_container_running 2 "scoped-runner"
assert_container_env 2 "scoped-runner" "SERVICE_TIER" "gold"
assert_container_env 2 "scoped-runner" "SERVICE_PORT" "9095"

grade_finish
