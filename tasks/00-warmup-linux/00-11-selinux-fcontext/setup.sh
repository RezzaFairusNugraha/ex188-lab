#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-11"
run_privileged semanage fcontext -d '/srv/ex188-webroot(/.*)?' >/dev/null 2>&1 || true
run_privileged rm -rf /srv/ex188-webroot
run_privileged mkdir -p /srv/ex188-webroot/assets
printf 'Initial Draft\n' | run_privileged tee /srv/ex188-webroot/assets/banner.txt >/dev/null
run_privileged restorecon -Rv /srv/ex188-webroot >/dev/null 2>&1 || true
