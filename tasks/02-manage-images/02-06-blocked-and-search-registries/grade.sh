#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-06"
CONF="$(student_home)/.config/containers/registries.conf"

assert_file_exists 3 "${CONF}" "User registries.conf exists"
assert_file_contains 4 "${CONF}" 'unqualified-search-registries *= *\["secure-reg\.lab\.local:5443", *"registry\.access\.redhat\.com"\]' "Search order prioritizes secure-reg.lab.local:5443 then registry.access.redhat.com"
check_cmd 5 "Pulling from untrusted-public.example.io fails immediately with blocked-registry error" \
    "pull from untrusted-public.example.io was not rejected as blocked" \
    bash -c "podman pull untrusted-public.example.io/bad/app:1.0 2>&1 | grep -qi 'blocked'"
check_cmd 5 "Short-name pull 'podman pull approved/mini-tool:1.0' resolves from secure-reg.lab.local:5443" \
    "short-name pull approved/mini-tool:1.0 failed" \
    podman pull approved/mini-tool:1.0
assert_image_exists 3 "localhost/mini-tool:verified"

grade_finish
