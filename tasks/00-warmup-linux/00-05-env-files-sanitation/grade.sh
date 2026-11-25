#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "00-05"
TARGET_SITE="${TARGET_SITE:-dc-west}"
SHOME="/home/$(student_user)"
PROF="${SHOME}/.bashrc.d/ex188-profile.sh"
ENVF="${SHOME}/workspace/00-05/container.env"

assert_file_exists 2 "${PROF}" "Profile drop-in ${PROF} exists"
check_cmd 2 "Sourcing ${PROF} exports EX188_SITE=${TARGET_SITE}" \
    "EX188_SITE not exported or wrong value when sourcing ${PROF}" \
    bash -c "source '${PROF}' && [[ \"\${EX188_SITE:-}\" == '${TARGET_SITE}' ]] && env | grep -qx 'EX188_SITE=${TARGET_SITE}'"

assert_file_exists 2 "${ENVF}" "Sanitized env file ${ENVF} exists"
if [[ -f "${ENVF}" ]] \
    && grep -qx 'APP_PORT=8080' "${ENVF}" \
    && grep -qx 'APP_ENV=production' "${ENVF}" \
    && grep -qx 'LOG_LEVEL=info' "${ENVF}" \
    && grep -qx 'CACHE_TTL=120' "${ENVF}" \
    && ! grep -Eq '^(export |#|$)' "${ENVF}"; then
    pass_check 4 "container.env contains clean unquoted KEY=VALUE lines with no 'export' or comments"
else
    fail_check 4 "container.env format verification" "file still has 'export ', quotes, comments, or missing keys"
fi

grade_finish
