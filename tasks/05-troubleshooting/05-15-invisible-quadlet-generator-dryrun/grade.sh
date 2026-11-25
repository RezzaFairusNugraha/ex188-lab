#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-15"
SHOME="$(student_home)"

check_cmd 3 "Misplaced file removed from ~/.config/systemd/user/" \
    "broken-quad.container still in ~/.config/systemd/user/" \
    bash -c "[[ ! -f '${SHOME}/.config/systemd/user/broken-quad.container' ]]"
assert_file_exists 3 "${SHOME}/.config/containers/systemd/broken-quad.container" "Quadlet moved to ~/.config/containers/systemd/"
check_cmd 4 "podman-system-generator --user --dryrun exits 0" \
    "podman-system-generator --user --dryrun reported errors" \
    /usr/lib/systemd/system-generators/podman-system-generator --user --dryrun
assert_service_persistent 5 "user" "broken-quad.service"
assert_http_ok 5 "http://127.0.0.1:8515/" "nginx"

grade_finish
