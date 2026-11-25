#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-16"

check_cmd 4 "Network corp-net exists with subnet 10.88.40.0/24" \
    "network corp-net missing or wrong subnet" \
    bash -c "podman network inspect corp-net | grep -q '10.88.40.0/24'"
assert_container_running 2 "static-node"
check_cmd 4 "Container static-node has IP 10.88.40.55 on corp-net" \
    "static-node IP on corp-net is not 10.88.40.55" \
    bash -c "[[ \"\$(podman inspect --format '{{(index .NetworkSettings.Networks \"corp-net\").IPAddress}}' static-node)\" == '10.88.40.55' ]]"

grade_finish
