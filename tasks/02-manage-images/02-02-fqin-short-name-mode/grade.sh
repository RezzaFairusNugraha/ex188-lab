#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-02"
CONF="$(student_home)/.config/containers/registries.conf"

assert_file_exists 2 "${CONF}" "User registries.conf exists at ${CONF}"
assert_file_contains 3 "${CONF}" 'unqualified-search-registries *= *\["registry\.access\.redhat\.com", *"quay\.io"\]' "unqualified-search-registries configured without docker.io"
assert_file_contains 3 "${CONF}" 'short-name-mode *= *"enforcing"' "short-name-mode set to enforcing"
assert_image_exists 2 "localhost/fqin-verified:1.0"

grade_finish
