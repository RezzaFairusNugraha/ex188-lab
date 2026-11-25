#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
seed_load "00-09"
APP_TCP_PORT="${APP_TCP_PORT:-8448}"
run_privileged firewall-cmd --permanent --remove-port="${APP_TCP_PORT}/tcp" >/dev/null 2>&1 || true
run_privileged firewall-cmd --permanent --remove-port="5514/udp" >/dev/null 2>&1 || true
run_privileged firewall-cmd --permanent --remove-port="9999/tcp" >/dev/null 2>&1 || true
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true
