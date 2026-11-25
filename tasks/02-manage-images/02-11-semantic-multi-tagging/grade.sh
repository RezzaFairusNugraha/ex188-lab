#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "02-11"

for t in 2.3.1 2.3 2 latest; do
    assert_registry_image 2 "registry.lab.local:5000/web/portal:${t}" "--tls-verify=false" "Remote tag web/portal:${t} pushed"
done
assert_registry_image 2 "registry.lab.local:5000/archive/portal:2.3.1" "--tls-verify=false" "Archive tag archive/portal:2.3.1 pushed"

grade_finish
