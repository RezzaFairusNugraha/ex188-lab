#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "04-13"
YAML="$(student_home)/workspace/04-13/cm-secret-pod.yaml"

assert_file_contains 3 "${YAML}" "kind: ConfigMap" "YAML includes kind: ConfigMap"
assert_file_contains 3 "${YAML}" "kind: Secret" "YAML includes kind: Secret"
assert_http_ok 5 "http://127.0.0.1:8413/" "Kube ConfigMap Portal"
assert_http_ok 4 "http://127.0.0.1:8413/" '"secret_source": *"file"'

grade_finish
