#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-17"
IMG="localhost/hotfix-snapshot:1.1"

assert_image_exists 3 "${IMG}"
check_cmd 4 "Image Author equals student@lab.local and ENV HOTFIX_APPLIED=1.1" \
    "Author or HOTFIX_APPLIED metadata missing on committed image" \
    bash -c "[[ \"\$(podman image inspect --format '{{.Author}}' '${IMG}')\" == 'student@lab.local' ]] && podman run --rm --entrypoint env '${IMG}' | grep -qx 'HOTFIX_APPLIED=1.1'"
check_cmd 4 "Committed image adds a new layer on top of base RootFS.Layers (>= 2)" \
    "RootFS.Layers count < 2" \
    bash -c "(( \$(podman image inspect --format '{{len .RootFS.Layers}}' '${IMG}') >= 2 ))"
check_cmd 4 "/etc/hotfix.conf inside committed image contains both INITIAL=true and PATCH_VERIFIED=yes" \
    "/etc/hotfix.conf missing PATCH_VERIFIED=yes" \
    bash -c "podman run --rm '${IMG}' cat /etc/hotfix.conf | grep -q 'PATCH_VERIFIED=yes'"

grade_finish
