#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-11"

assert_file_contains 3 "/srv/ex188-webroot/assets/banner.txt" "SELinux Ready" "banner.txt contains 'SELinux Ready'"
check_cmd 5 "Persistent semanage fcontext rule exists for /srv/ex188-webroot" \
    "no local semanage fcontext rule mapping /srv/ex188-webroot to container_file_t" \
    bash -c "run_privileged semanage fcontext -l -C | grep -E '/srv/ex188-webroot' | grep -q 'container_file_t'"

# Run restorecon to prove chcon was not used without policy!
run_privileged restorecon -Rv /srv/ex188-webroot >/dev/null 2>&1 || true
assert_selinux_type 4 "/srv/ex188-webroot" "container_file_t" "Directory /srv/ex188-webroot retains container_file_t after restorecon"
assert_selinux_type 3 "/srv/ex188-webroot/assets/banner.txt" "container_file_t" "Nested banner.txt retains container_file_t after restorecon"

grade_finish
