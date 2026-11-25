#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-11"
SHOME="$(student_home)"

check_cmd 5 "auth-reg.lab.local:5444 is no longer blocked" \
    "auth-reg.lab.local:5444 is still marked blocked" \
    bash -c "! grep -A2 'auth-reg.lab.local:5444' '${SHOME}/.config/containers/registries.conf' 2>/dev/null | grep -q 'blocked *= *true'"
check_cmd 5 "Authenticated pull using ~/.config/containers/auth.json succeeds" \
    "pull with ~/.config/containers/auth.json failed (still has stale credentials)" \
    podman pull --tls-verify=true --authfile "${SHOME}/.config/containers/auth.json" auth-reg.lab.local:5444/sec/scanner:2.0
assert_container_running 5 "sec-scanner"

grade_finish
