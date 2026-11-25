#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-22"
WORK="$(student_home)/workspace/01-22"

assert_container_running 3 "keep-alive-svc"
check_cmd 3 "Stopped containers exited-job-1 and exited-job-2 have been pruned" \
    "exited containers still exist in podman ps -a" \
    bash -c "! podman container exists exited-job-1 && ! podman container exists exited-job-2"
check_cmd 2 "Zero dangling images remain (podman images -f dangling=true -q)" \
    "dangling <none> images still exist" \
    bash -c "[[ -z \"\$(podman images -f dangling=true -q)\" ]]"
assert_file_contains 2 "${WORK}/system-df.txt" "Images|Containers" "podman system df report saved to system-df.txt"

grade_finish
