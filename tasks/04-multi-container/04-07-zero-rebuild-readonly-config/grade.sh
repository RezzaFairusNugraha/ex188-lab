#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-07"
WORK="$(student_home)/workspace/04-07"
ORIG_ID="$(cat "${WORK}/.orig_id")"

check_cmd 3 "Image localhost/static-portal:1.0 was NOT rebuilt" \
    "Image ID of localhost/static-portal:1.0 changed (task forbids rebuilding)" \
    bash -c "[[ \"\$(podman image inspect --format '{{.Id}}' localhost/static-portal:1.0)\" == '${ORIG_ID}' ]]"
assert_container_running 2 "portal-configured"
assert_container_mount 2 "portal-configured" "/usr/share/nginx/html/config.js" "ro"
assert_http_ok 3 "http://127.0.0.1:8407/config.js" "Zero-Rebuild Production Override"

grade_finish
