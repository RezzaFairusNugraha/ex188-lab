#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-03"
CONF="/etc/containers/registries.conf.d/50-lab-http.conf"

assert_file_exists 3 "${CONF}" "Drop-in ${CONF} exists"
assert_file_contains 3 "${CONF}" 'location *= *"registry\.lab\.local:5000"' "Configures location = registry.lab.local:5000"
assert_file_contains 3 "${CONF}" 'insecure *= *true' "Marks registry insecure = true"
check_cmd 6 "podman pull registry.lab.local:5000/dev/base-ubi:1.0 succeeds WITHOUT --tls-verify=false" \
    "pull without --tls-verify=false failed (check TOML [[registry]] syntax or push status)" \
    podman pull registry.lab.local:5000/dev/base-ubi:1.0

grade_finish
