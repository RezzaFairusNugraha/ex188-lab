#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-17"

assert_image_exists 2 "localhost/api-express:1.0"
assert_container_running 2 "inventory-api"
assert_container_mount 3 "inventory-api" "/etc/api-express/catalog.json" "ro"
assert_container_mount 3 "inventory-api" "/var/lib/api-express/audit" "rw"
assert_http_ok 2 "http://127.0.0.1:3017/api/v1/info" '"catalog_count": *2'
check_cmd 3 "Named volume api-audit-vol contains audit.log" \
    "audit.log not found on named volume api-audit-vol" \
    bash -c "mp=\$(podman volume inspect --format '{{.Mountpoint}}' api-audit-vol) && test -s \"\${mp}/audit.log\""

grade_finish
