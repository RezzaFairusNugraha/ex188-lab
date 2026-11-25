#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-16"
WORK="$(student_home)/workspace/01-16"
IMG="localhost/webapp-vol:1.0"

assert_image_exists 2 "${IMG}"
check_cmd 3 "Image metadata declares VOLUME /var/lib/webapp/data" \
    "Config.Volumes missing /var/lib/webapp/data" \
    bash -c "podman image inspect --format '{{json .Config.Volumes}}' '${IMG}' | grep -q '/var/lib/webapp/data'"
assert_container_running 3 "notes-writer"
assert_selinux_type 3 "${WORK}/host-notes" "container_file_t" "host-notes relabeled to container_file_t (:Z)"
assert_file_contains 4 "${WORK}/host-notes/entries.log" "first-persistent-note" "entries.log persisted on host bind mount"

grade_finish
