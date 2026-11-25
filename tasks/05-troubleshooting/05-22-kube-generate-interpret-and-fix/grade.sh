#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-22"
YAML="$(student_home)/workspace/05-22/remediated-pod.yaml"

assert_file_exists 2 "${YAML}" "Manifest ${YAML} exists"
assert_file_contains 3 "${YAML}" "memory: *192Mi" "YAML defines memory: 192Mi limit"
assert_http_ok 4 "http://127.0.0.1:8522/healthz" '"reachable": *true'
assert_http_ok 3 "http://127.0.0.1:8522/" '"env": *"production"'
check_cmd 3 "Container misconfigured-pod-web enforces 192Mi (201326592 bytes) memory limit" \
    "HostConfig.Memory on misconfigured-pod-web is not 201326592" \
    bash -c "[[ \"\$(podman inspect --format '{{.HostConfig.Memory}}' misconfigured-pod-web)\" == '201326592' ]]"

grade_finish
