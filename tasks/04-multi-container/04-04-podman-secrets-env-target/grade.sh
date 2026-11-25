#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-04"

check_cmd 3 "Podman secret pg_admin_pass exists" "secret pg_admin_pass missing" podman secret exists pg_admin_pass
assert_container_running 3 "secure-pg"
assert_container_mount 3 "secure-pg" "/var/lib/pgsql/data" "rw"
check_cmd 3 "Plaintext password PgSecret_9081 is NOT exposed in podman inspect" \
    "PgSecret_9081 leaked in plain text inside podman inspect!" \
    bash -c "! podman inspect secure-pg | grep -q 'PgSecret_9081'"
check_cmd 3 "PostgreSQL ordersdb accepts SQL queries as appuser" \
    "PostgreSQL did not accept PGPASSWORD=PgSecret_9081 psql connection" \
    bash -c "podman exec -e PGPASSWORD=PgSecret_9081 secure-pg psql -h 127.0.0.1 -U appuser -d ordersdb -c 'SELECT 1;' >/dev/null"

grade_finish
