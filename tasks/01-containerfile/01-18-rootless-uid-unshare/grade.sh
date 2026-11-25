#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-18"
WORK="$(student_home)/workspace/01-18"
SUID="$(student_uid)"

assert_image_user 3 "localhost/worker-uid1001:1.0" "1001"
assert_container_running 3 "worker-unshare"
assert_container_running 3 "worker-keepid"

check_cmd 4 "unshare-spool is owned on host by subordinate UID (!= student UID ${SUID})" \
    "unshare-spool is still owned by host student UID instead of podman unshare subordinate UID" \
    bash -c "[[ \"\$(stat -c '%u' '${WORK}/unshare-spool')\" != '${SUID}' ]]"

check_cmd 3 "keepid-spool remains owned on host by student UID (${SUID})" \
    "keepid-spool host UID is not ${SUID}" \
    bash -c "[[ \"\$(stat -c '%u' '${WORK}/keepid-spool')\" == '${SUID}' ]]"

podman unshare sh -c "echo alpha > '${WORK}/unshare-spool/inbox/g1.job'" 2>/dev/null || true
echo beta > "${WORK}/keepid-spool/inbox/g2.job" 2>/dev/null || true
sleep 2

check_cmd 4 "Both worker-unshare and worker-keepid wrote processed .done files to outbox" \
    "one or both containers failed to process .job into outbox" \
    bash -c "test -s '${WORK}/unshare-spool/outbox/g1.done' && test -s '${WORK}/keepid-spool/outbox/g2.done'"

grade_finish
