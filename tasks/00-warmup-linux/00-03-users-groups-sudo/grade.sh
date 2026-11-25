#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-03"
TARGET_UID="${TARGET_UID:-2401}"

check_cmd 1 "Group 'containerops' exists with GID 2450" "group containerops missing or wrong GID" \
    bash -c '[[ "$(getent group containerops | cut -d: -f3)" == "2450" ]]'

check_cmd 2 "User 'svcrunner' has UID ${TARGET_UID}, shell /sbin/nologin, and group containerops" \
    "svcrunner UID, shell, or supplementary group does not match requirements" \
    bash -c "[[ \"\$(id -u svcrunner 2>/dev/null)\" == \"${TARGET_UID}\" ]] && getent passwd svcrunner | grep -q '/sbin/nologin$' && id -nG svcrunner | tr ' ' '\n' | grep -qx 'containerops'"

check_cmd 2 "Sudoers drop-in /etc/sudoers.d/ex188-svcrunner has mode 0440 and passes visudo -cf" \
    "/etc/sudoers.d/ex188-svcrunner missing, wrong mode, or invalid syntax" \
    bash -c 'run_privileged test -f /etc/sudoers.d/ex188-svcrunner && [[ "$(run_privileged stat -c %a /etc/sudoers.d/ex188-svcrunner)" == "440" ]] && run_privileged visudo -cf /etc/sudoers.d/ex188-svcrunner'

grade_finish
