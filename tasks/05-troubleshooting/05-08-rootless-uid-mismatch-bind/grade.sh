#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-08"
JDIR="$(student_home)/workspace/05-08/journal"

assert_container_running 3 "uid-victim"
check_cmd 4 "Container still runs as UID 1001 and directory is not mode 0777" \
    "container UID changed to 0 or directory set to 777" \
    bash -c "[[ \"\$(podman exec uid-victim id -u)\" == '1001' ]] && [[ \"\$(stat -c '%a' '${JDIR}')\" != '777' ]]"
check_cmd 4 "POST /entries?msg=uid-fixed succeeds with HTTP 201" \
    "POST /entries failed" \
    bash -c "[[ \"\$(curl -s -o /dev/null -w '%{http_code}' -X POST 'http://127.0.0.1:8508/entries?msg=uid-fixed')\" == '201' ]]"
assert_file_contains 4 "${JDIR}/entries.log" "uid-fixed" "entries.log written on host bind mount"

grade_finish
