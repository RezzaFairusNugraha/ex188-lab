#!/usr/bin/env bash
set -euo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/exam_setup_helper.sh"
exam_reset_prefix m03 18301 18302 18303
