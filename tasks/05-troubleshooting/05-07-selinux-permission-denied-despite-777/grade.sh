#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-07"
DATA="$(student_home)/workspace/05-07/data"

check_cmd 3 "Host SELinux remains Enforcing and container confinement is enabled" \
    "SELinux was disabled or label=disable was used!" \
    bash -c "[[ \"\$(getenforce 2>/dev/null || echo Enforcing)\" != 'Permissive' ]] && ! podman inspect --format '{{.ProcessLabel}}' selinux-victim | grep -qx ''"
check_cmd 3 "Insecure 0777 permissions removed from ${DATA}" \
    "${DATA} is still mode 777" \
    bash -c "[[ \"\$(stat -c '%a' '${DATA}')\" != '777' ]]"
assert_selinux_type 4 "${DATA}" "container_file_t" "Directory relabeled to container_file_t"
assert_http_ok 5 "http://127.0.0.1:8507/healthz" '"storage": *"writable"'

grade_finish
