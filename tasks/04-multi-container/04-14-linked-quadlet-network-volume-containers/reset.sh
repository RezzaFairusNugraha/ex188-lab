#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
QDIR="${SHOME}/.config/containers/systemd"
systemctl --user stop q-web.service q-db.service tier-net-network.service tier-pg-volume.service >/dev/null 2>&1 || true
rm -f "${QDIR}/tier-net.network" "${QDIR}/tier-pg.volume" "${QDIR}/q-db.container" "${QDIR}/q-web.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f q-web q-db >/dev/null 2>&1 || true
podman network rm -f tier-net >/dev/null 2>&1 || true
podman volume rm -f tier-pg >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0414:1.0 >/dev/null 2>&1 || true
