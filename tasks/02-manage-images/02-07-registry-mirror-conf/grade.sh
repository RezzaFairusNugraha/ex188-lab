#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-07"
CONF="/etc/containers/registries.conf.d/60-corp-mirror.conf"

assert_file_exists 4 "${CONF}" "Drop-in ${CONF} exists"
assert_file_contains 4 "${CONF}" '\[\[registry\.mirror\]\]' "Uses [[registry.mirror]] table syntax"
assert_file_contains 4 "${CONF}" 'secure-reg\.lab\.local:5443' "Points mirror location to secure-reg.lab.local:5443"
podman rmi -f upstream-hub.corp.example/platform/agent:2.1 >/dev/null 2>&1 || true
check_cmd 8 "podman pull upstream-hub.corp.example/platform/agent:2.1 succeeds via [[registry.mirror]]" \
    "pull of upstream-hub.corp.example/platform/agent:2.1 failed" \
    podman pull upstream-hub.corp.example/platform/agent:2.1

grade_finish
