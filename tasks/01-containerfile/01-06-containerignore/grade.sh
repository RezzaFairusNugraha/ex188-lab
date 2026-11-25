#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-06"
WORK="$(student_home)/workspace/01-06"
IMG="localhost/clean-context:1.0"

assert_file_exists 2 "${WORK}/.containerignore" ".containerignore exists"
assert_file_exists 1 "${WORK}/.env.secret" "Host .env.secret was preserved on disk (not deleted)"
assert_image_exists 2 "${IMG}"
check_cmd 2 "service.py and config/default.json are present in /opt/service" \
    "expected application files missing from /opt/service" \
    bash -c "podman run --rm '${IMG}' test -f /opt/service/service.py && podman run --rm '${IMG}' test -f /opt/service/config/default.json"
check_cmd 3 "No .git, .env.secret, debug.log, notes.bak, or Containerfile leaked into /opt/service" \
    "prohibited files were found inside /opt/service in the built image" \
    bash -c "out=\$(podman run --rm '${IMG}' ls -A /opt/service); ! grep -Eq '(\.git|\.secret|\.log|\.bak|Containerfile|\.containerignore)' <<< \"\${out}\""

grade_finish
