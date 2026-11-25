#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-23"
IMG_TAG="${IMG_TAG:-1.2}"
HOST_PORT="${HOST_PORT:-3023}"
IMG="localhost/northwind-api:${IMG_TAG}"
WORK="$(student_home)/workspace/01-23"

assert_image_exists 2 "${IMG}"
assert_image_user 3 "${IMG}" "1001"
check_cmd 3 "Vendor server.js inside image is unmodified" \
    "server.js checksum inside image differs from vendor source!" \
    bash -c "[[ \"\$(podman run --rm --entrypoint sha256sum '${IMG}' /opt/api-express/server.js | awk '{print \$1}')\" == \"\$(sha256sum '${LAB_APPS_DIR}/api-express/server.js' | awk '{print \$1}')\" ]]"
assert_container_running 2 "northwind-prod"
assert_http_ok 2 "http://127.0.0.1:${HOST_PORT}/api/v1/items" "RHEL-SUB-01"
check_cmd 3 "Authenticated POST /api/v1/audit returns 201 and rejects unauthenticated requests (401)" \
    "POST /api/v1/audit failed with token or accepted request without token" \
    bash -c "[[ \"\$(curl -s -o /dev/null -w '%{http_code}' -X POST http://127.0.0.1:${HOST_PORT}/api/v1/audit)\" == '401' ]] && [[ \"\$(curl -s -o /dev/null -w '%{http_code}' -X POST -H 'X-API-Token: nw-prod-9912' http://127.0.0.1:${HOST_PORT}/api/v1/audit)\" == '201' ]]"

grade_finish
