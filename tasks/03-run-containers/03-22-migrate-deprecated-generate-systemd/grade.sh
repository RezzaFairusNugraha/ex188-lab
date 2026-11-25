#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-22"
SHOME="$(student_home)"

check_cmd 3 "Deprecated container-legacy-cache.service unit file removed" \
    "container-legacy-cache.service still exists in ~/.config/systemd/user" \
    bash -c "[[ ! -f '${SHOME}/.config/systemd/user/container-legacy-cache.service' ]]"
assert_file_exists 3 "${SHOME}/.config/containers/systemd/legacy-cache.container" "Quadlet legacy-cache.container exists"
assert_service_persistent 5 "user" "legacy-cache.service"
assert_container_port 4 "legacy-cache" "6379/tcp" "16379" "127.0.0.1"
check_cmd 5 "Redis key MIGRATION_CHECK == PRESERVED_99 and memory limit == 128m" \
    "MIGRATION_CHECK lost or memory limit != 134217728" \
    bash -c "[[ \"\$(podman exec legacy-cache redis-cli GET MIGRATION_CHECK)\" == 'PRESERVED_99' ]] && [[ \"\$(podman inspect --format '{{.HostConfig.Memory}}' legacy-cache)\" == '134217728' ]]"

grade_finish
