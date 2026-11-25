#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-12"
WORK="$(student_home)/workspace/00-12"

check_cmd 5 "SELinux boolean container_manage_cgroup is enabled persistently" \
    "container_manage_cgroup is off in runtime or persistent policy (did you pass -P?)" \
    bash -c '[[ "$(getsebool container_manage_cgroup | awk "{print \$3}")" == "on" ]] && run_privileged semanage boolean -l | grep -Eq "^container_manage_cgroup[[:space:]]+\(on[[:space:]]*,[[:space:]]*on\)"'

assert_file_contains 3 "${WORK}/firewalld-type.txt" "^firewalld_t$" "firewalld SELinux domain (firewalld_t) recorded"

SHARED_CTX="$(stat -c '%C' "${WORK}/shared-dir" 2>/dev/null || true)"
if [[ "${SHARED_CTX}" == *":container_file_t:s0" ]]; then
    pass_check 3 "shared-dir labeled with shared container_file_t:s0 (:z)"
else
    fail_check 3 "shared-dir SELinux context check" "got '${SHARED_CTX}', expected ':container_file_t:s0' without MCS categories"
fi

PRIV_CTX="$(stat -c '%C' "${WORK}/private-dir" 2>/dev/null || true)"
if [[ "${PRIV_CTX}" =~ :container_file_t:s0:c[0-9]+,c[0-9]+ ]]; then
    pass_check 4 "private-dir labeled with private MCS categories (:Z)"
else
    fail_check 4 "private-dir SELinux context check" "got '${PRIV_CTX}', expected ':container_file_t:s0:cX,cY'"
fi

grade_finish
