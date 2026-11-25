#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
QDIR="${SHOME}/.config/containers/systemd"
systemctl --user stop telemetry-web.service telemetry-redis.service telemetry-stack-pod.service >/dev/null 2>&1 || true
rm -f "${QDIR}/telemetry-stack.pod" "${QDIR}/telemetry-redis.container" "${QDIR}/telemetry-web.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman pod rm -f telemetry-stack >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0415:1.0 >/dev/null 2>&1 || true
