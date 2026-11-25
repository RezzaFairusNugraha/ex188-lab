#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-12"
WORK="$(student_home)/workspace/03-12"

assert_file_contains 5 "${WORK}/mounts.txt" "^bind:/etc/meta-cfg$" "mounts.txt includes bind:/etc/meta-cfg"
assert_file_contains 2 "${WORK}/mounts.txt" "^volume:/var/lib/meta-data$" "mounts.txt includes volume:/var/lib/meta-data"
assert_file_contains 4 "${WORK}/cost-center.txt" "^CC-8841-RHEL$" "cost-center.txt contains CC-8841-RHEL"
check_cmd 4 "features.env contains FEATURE_BILLING and FEATURE_SEARCH only" \
    "features.env missing FEATURE_* vars or includes INTERNAL_NOISE" \
    bash -c "grep -qx 'FEATURE_BILLING=enabled' '${WORK}/features.env' && grep -qx 'FEATURE_SEARCH=beta' '${WORK}/features.env' && ! grep -q 'INTERNAL_NOISE' '${WORK}/features.env'"

grade_finish
