#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-17"

assert_container_running 4 "prod-keeper"
check_cmd 4 "Active data /data/keep.txt on prod-keeper-vol preserved" \
    "keep.txt missing inside prod-keeper!" \
    bash -c "podman exec prod-keeper cat /data/keep.txt | grep -qx 'DO_NOT_LOSE'"
check_cmd 4 "Stopped junk containers and orphan-vol-1 removed" \
    "junk-crash-2 or orphan-vol-1 still exists" \
    bash -c "! podman container exists junk-crash-2 && ! podman volume exists orphan-vol-1"
check_cmd 3 "Unused image localhost/bloated-junk:old removed" \
    "localhost/bloated-junk:old still exists" \
    bash -c "! podman image exists localhost/bloated-junk:old"

grade_finish
