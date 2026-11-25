#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-14"
TAR="$(student_home)/workspace/02-14/backup-demo-oci.tar"

assert_file_exists 2 "${TAR}" "Archive ${TAR} exists"
check_cmd 4 "Tarball is a valid OCI archive (contains oci-layout)" \
    "tarball does not contain oci-layout (did you use --format oci-archive?)" \
    bash -c "tar -tf '${TAR}' | grep -qx 'oci-layout'"
assert_image_exists 2 "localhost/backup-demo:1.0"
assert_image_user 2 "localhost/backup-demo:1.0" "1001"

grade_finish
