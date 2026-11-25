#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-16"
TAR="$(student_home)/workspace/02-16/rootfs.tar"
IMG="localhost/flattened-box:1.0"

assert_file_exists 3 "${TAR}" "Exported rootfs tarball ${TAR} exists"
assert_image_exists 2 "${IMG}"
assert_image_user 3 "${IMG}" "1001"
check_cmd 3 "Flattened image has exactly 1 layer in RootFS.Layers" \
    "RootFS.Layers count is not 1 (was podman commit used instead of export/import?)" \
    bash -c "[[ \"\$(podman image inspect --format '{{len .RootFS.Layers}}' '${IMG}')\" == '1' ]]"
check_cmd 4 "Running localhost/flattened-box:1.0 outputs stamp-0216 and has FLATTENED=true" \
    "container output or FLATTENED env did not match" \
    bash -c "[[ \"\$(podman run --rm '${IMG}')\" == 'stamp-0216' ]] && podman run --rm --entrypoint env '${IMG}' | grep -qx 'FLATTENED=true'"

grade_finish
