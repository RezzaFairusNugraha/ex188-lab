#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-08"
APP_UID="${APP_UID:-1001}"
IMG="localhost/webapp-flask:1.0"

assert_image_exists 3 "${IMG}"
assert_image_user 3 "${IMG}" "${APP_UID}"
check_cmd 3 "Image WorkingDir is /opt/webapp" "WorkingDir is not /opt/webapp" \
    bash -c "[[ \"\$(podman image inspect --format '{{.Config.WorkingDir}}' '${IMG}')\" == '/opt/webapp' ]]"
check_cmd 6 "Ephemeral container serves / and reports uid=${APP_UID} & env=production" \
    "webapp-flask container failed to start or reported wrong uid/env" \
    bash -c "podman rm -f grade-01-08 >/dev/null 2>&1 || true; podman run -d --name grade-01-08 -p 18808:8080 '${IMG}' >/dev/null && sleep 2 && out=\$(curl -fsS http://127.0.0.1:18808/) && podman rm -f grade-01-08 >/dev/null && grep -q '\"uid\": *${APP_UID}' <<< \"\${out}\" && grep -q '\"env\": *\"production\"' <<< \"\${out}\""

grade_finish
