#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-03"

check_cmd 2 "Podman secret nw_token exists" "secret nw_token missing" podman secret exists nw_token
assert_container_running 2 "sec-mount-api"
check_cmd 3 "Secret value does NOT leak into Config.Env" \
    "TokenMount_4491 leaked into container Config.Env" \
    bash -c "! podman inspect --format '{{json .Config.Env}}' sec-mount-api | grep -q 'TokenMount_4491'"
check_cmd 3 "Authenticated POST /api/v1/audit returns 201" \
    "POST /api/v1/audit with X-API-Token: TokenMount_4491 did not return 201" \
    bash -c "[[ \"\$(curl -s -o /dev/null -w '%{http_code}' -X POST -H 'X-API-Token: TokenMount_4491' http://127.0.0.1:3403/api/v1/audit)\" == '201' ]]"

grade_finish
