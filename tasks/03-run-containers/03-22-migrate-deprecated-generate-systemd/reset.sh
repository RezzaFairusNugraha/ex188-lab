#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
systemctl --user disable --now container-legacy-cache.service >/dev/null 2>&1 || true
systemctl --user stop legacy-cache.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/systemd/user/container-legacy-cache.service" "${SHOME}/.config/containers/systemd/legacy-cache.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f legacy-cache >/dev/null 2>&1 || true
podman volume rm -f legacy-redis-data >/dev/null 2>&1 || true
