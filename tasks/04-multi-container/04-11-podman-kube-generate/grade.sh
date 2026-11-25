#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-11"
YAML="$(student_home)/workspace/04-11/exported-stack.yaml"

assert_file_exists 3 "${YAML}" "Exported manifest ${YAML} exists"
assert_file_contains 3 "${YAML}" "^kind: Service$" "Manifest includes Kubernetes Service (-s flag)"
assert_file_contains 3 "${YAML}" "^kind: Pod$" "Manifest includes Kubernetes Pod"
check_cmd 3 "Pod export-source-pod is Running via kube play" \
    "Pod export-source-pod is not Running" \
    bash -c "[[ \"\$(podman pod inspect --format '{{.State}}' export-source-pod 2>/dev/null)\" == 'Running' ]]"
assert_http_ok 3 "http://127.0.0.1:8411/healthz" '"reachable": *true'

grade_finish
