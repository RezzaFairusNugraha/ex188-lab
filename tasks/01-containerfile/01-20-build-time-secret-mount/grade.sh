#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-20"
WORK="$(student_home)/workspace/01-20"
IMG="localhost/secret-safe:1.0"
EXP_HASH="$(sha256sum "${WORK}/repo-credential.txt" | awk '{print $1}')"

assert_file_contains 3 "${WORK}/Containerfile" "--mount=type=secret,id=repo_cred" "Containerfile uses RUN --mount=type=secret,id=repo_cred"
assert_image_exists 3 "${IMG}"
check_cmd 4 "/etc/cred-fingerprint matches expected SHA256 of repo-credential.txt" \
    "/etc/cred-fingerprint missing or wrong digest" \
    bash -c "[[ \"\$(podman run --rm '${IMG}' cat /etc/cred-fingerprint)\" == '${EXP_HASH}' ]]"
check_cmd 5 "Raw token absent from podman history and image filesystem" \
    "raw token leaked into image history or filesystem!" \
    bash -c "! podman history --no-trunc '${IMG}' | grep -q 'Tok_PrivateBuildRepo' && ! podman run --rm '${IMG}' grep -rn 'Tok_PrivateBuildRepo' /etc /run /tmp 2>/dev/null"

grade_finish
