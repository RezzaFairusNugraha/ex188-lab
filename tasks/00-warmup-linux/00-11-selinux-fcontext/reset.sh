#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
run_privileged semanage fcontext -d '/srv/ex188-webroot(/.*)?' >/dev/null 2>&1 || true
run_privileged rm -rf /srv/ex188-webroot
