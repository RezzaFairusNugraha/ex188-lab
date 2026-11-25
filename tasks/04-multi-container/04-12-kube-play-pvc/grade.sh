#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-12"
YAML="$(student_home)/workspace/04-12/pvc-stack.yaml"

assert_file_contains 3 "${YAML}" "kind: PersistentVolumeClaim" "YAML defines PersistentVolumeClaim"
check_cmd 4 "Podman named volume notes-pvc created automatically by kube play" \
    "named volume notes-pvc missing" podman volume exists notes-pvc
check_cmd 4 "Pod notes-kube-pod is Running" "notes-kube-pod is not Running" \
    bash -c "[[ \"\$(podman pod inspect --format '{{.State}}' notes-kube-pod 2>/dev/null)\" == 'Running' ]]"
assert_http_ok 4 "http://127.0.0.1:8412/entries" "kube-pvc-persisted"

grade_finish
