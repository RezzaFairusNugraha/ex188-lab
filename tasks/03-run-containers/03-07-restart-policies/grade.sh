#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-07"

assert_container_running 2 "retry-bounded"
check_cmd 3 "retry-bounded has RestartPolicy on-failure with MaximumRetryCount=3" \
    "RestartPolicy on retry-bounded is not on-failure:3" \
    bash -c "[[ \"\$(podman inspect --format '{{.HostConfig.RestartPolicy.Name}}:{{.HostConfig.RestartPolicy.MaximumRetryCount}}' retry-bounded)\" == 'on-failure:3' ]]"
assert_container_running 2 "retry-always"
check_cmd 3 "retry-always has RestartPolicy always and podman-restart.service is enabled" \
    "retry-always policy is not always or podman-restart.service not enabled" \
    bash -c "[[ \"\$(podman inspect --format '{{.HostConfig.RestartPolicy.Name}}' retry-always)\" == 'always' ]] && systemctl --user is-enabled --quiet podman-restart.service"

grade_finish
