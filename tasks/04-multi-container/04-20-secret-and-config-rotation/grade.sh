#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-20"

assert_container_running 2 "rotatable-api"
assert_http_ok 4 "http://127.0.0.1:3420/api/v1/info" '"catalog_count": *3'
check_cmd 4 "RotatedToken_2026 accepted (201) and OldExpiredToken rejected (401)" \
    "token rotation verification failed on /api/v1/audit" \
    bash -c "[[ \"\$(curl -s -o /dev/null -w '%{http_code}' -X POST -H 'X-API-Token: OldExpiredToken' http://127.0.0.1:3420/api/v1/audit)\" == '401' ]] && [[ \"\$(curl -s -o /dev/null -w '%{http_code}' -X POST -H 'X-API-Token: RotatedToken_2026' http://127.0.0.1:3420/api/v1/audit)\" == '201' ]]"

grade_finish
