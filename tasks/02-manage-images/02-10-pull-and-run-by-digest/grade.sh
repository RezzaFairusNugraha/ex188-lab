#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-10"
WORK="$(student_home)/workspace/02-10"
EXP_DIG="$(cat "${WORK}/.expected-digest")"
EXP_REF="registry.lab.local:5000/sec/audit-runner@${EXP_DIG}"

assert_file_contains 5 "${WORK}/pinned-ref.txt" "^${EXP_REF}$" "pinned-ref.txt records exact v1 @sha256 reference"
assert_container_running 4 "digest-runner"
check_cmd 6 "Container digest-runner runs the GOOD_V1 image referenced by @sha256" \
    "digest-runner image reference or /etc/audit-release content does not match v1 digest" \
    bash -c "podman exec digest-runner cat /etc/audit-release | grep -qx 'GOOD_V1' && podman inspect --format '{{.ImageName}}' digest-runner | grep -q '@sha256:'"

grade_finish
