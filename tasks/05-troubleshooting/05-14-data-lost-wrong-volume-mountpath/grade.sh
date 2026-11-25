#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-14"

assert_container_running 3 "orders-db"
assert_container_mount 5 "orders-db" "/var/lib/pgsql/data" "rw"
check_cmd 3 "Volume orders-pgvol contains initialized PostgreSQL userdata/PG_VERSION" \
    "orders-pgvol is still empty on disk!" \
    bash -c "mp=\$(podman volume inspect --format '{{.Mountpoint}}' orders-pgvol) && ls \"\${mp}\" | grep -q ."
check_cmd 4 "Table shipments contains 'SHP-9901'" \
    "SELECT code FROM shipments did not return SHP-9901" \
    bash -c "podman exec orders-db psql -tA -U ord -d orddb -c 'SELECT code FROM shipments;' | grep -qx 'SHP-9901'"

grade_finish
