#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-23"

assert_container_running 3 "probed-nginx"
assert_container_healthy 5 "probed-nginx"
check_cmd 4 "Healthcheck retries == 3 and FailingStreak == 0" \
    "Healthcheck Retries is not 3" \
    bash -c "[[ \"\$(podman inspect --format '{{.Config.Healthcheck.Retries}}' probed-nginx)\" == '3' ]]"
check_cmd 3 "HealthcheckOnFailureAction is set to restart" \
    "Config.HealthcheckOnFailureAction is not restart" \
    bash -c "[[ \"\$(podman inspect --format '{{.Config.HealthcheckOnFailureAction}}' probed-nginx)\" == 'restart' ]]"

grade_finish
