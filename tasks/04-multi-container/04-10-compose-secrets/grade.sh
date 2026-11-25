#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-10"
WORK="$(student_home)/workspace/04-10"

check_cmd 3 "Podman secret compose_api_tok exists" "secret compose_api_tok missing" podman secret exists compose_api_tok
assert_file_not_contains 3 "${WORK}/compose.yaml" "ComposeSec_5520" "compose.yaml does not hard-code secret value"
assert_container_running 4 "compose-sec-api"
check_cmd 5 "POST /api/v1/audit with X-API-Token: ComposeSec_5520 returns 201" \
    "POST /api/v1/audit did not return 201" \
    bash -c "[[ \"\$(curl -s -o /dev/null -w '%{http_code}' -X POST -H 'X-API-Token: ComposeSec_5520' http://127.0.0.1:3410/api/v1/audit)\" == '201' ]]"

grade_finish
