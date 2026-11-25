#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-05"

check_cmd 2 "Original container customers-db-v1 was removed" "customers-db-v1 still exists" \
    bash -c "! podman container exists customers-db-v1"
assert_container_running 3 "customers-db-v2"
assert_container_mount 2 "customers-db-v2" "/var/lib/pgsql/data" "rw"
check_cmd 3 "Replacement container customers-db-v2 retains row 'RedHat-Enterprise'" \
    "SQL query on customers-db-v2 did not return RedHat-Enterprise" \
    bash -c "podman exec customers-db-v2 psql -tA -U crm -d crmdb -c 'SELECT name FROM accounts WHERE id=1;' | grep -qx 'RedHat-Enterprise'"

grade_finish
