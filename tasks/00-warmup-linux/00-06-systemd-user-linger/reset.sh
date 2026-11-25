#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
systemctl --user disable --now ex188-pulse.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/systemd/user/ex188-pulse.service"
systemctl --user daemon-reload >/dev/null 2>&1 || true
rm -rf "${SHOME}/workspace/00-06"
