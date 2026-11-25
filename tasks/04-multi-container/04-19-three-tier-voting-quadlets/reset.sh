#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
QDIR="${SHOME}/.config/containers/systemd"
systemctl --user stop qv-ui.service qv-api.service qv-db.service qv-cache.service qv-net-network.service qv-pg-volume.service qv-ballots-volume.service >/dev/null 2>&1 || true
rm -f "${QDIR}"/qv-*
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f qv-ui qv-api qv-db qv-cache >/dev/null 2>&1 || true
podman network rm -f qv-net >/dev/null 2>&1 || true
podman volume rm -f qv-pg qv-ballots >/dev/null 2>&1 || true
podman secret rm qv_db_pass >/dev/null 2>&1 || true
podman rmi -f localhost/qv-ui:1.0 localhost/qv-api:1.0 >/dev/null 2>&1 || true
rm -rf "${SHOME}/workspace/04-19"
