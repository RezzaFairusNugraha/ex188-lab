#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-01"
CNAME="${CNAME:-beacon-svc}"
WORK="$(student_home)/workspace/03-01"

assert_container_running 3 "${CNAME}"
check_cmd 3 "Container hostname is beacon.lab.internal and user is 1005:1005" \
    "hostname or user mismatch on ${CNAME}" \
    bash -c "[[ \"\$(podman inspect --format '{{.Config.Hostname}}|{{.Config.User}}' '${CNAME}')\" =~ ^beacon\.lab\.internal\|1005(:1005)?$ ]]"
assert_file_contains 2 "${WORK}/kernel.txt" "^$(uname -r)$" "kernel.txt matches host kernel version"
check_cmd 2 "No exited containers remain in podman ps -a (--rm used cleanly)" \
    "found exited containers in podman ps -a" \
    bash -c "[[ -z \"\$(podman ps -a --filter status=exited -q)\" ]]"

grade_finish
