#!/usr/bin/env bash
set -euo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
SHOME="$(student_home)"
QDIR="${SHOME}/.config/containers/systemd"
WORK="${SHOME}/workspace/m01"

[[ -f "${WORK}/compose-stack/compose.yaml" ]] && (cd "${WORK}/compose-stack" && podman-compose down -v >/dev/null 2>&1 || true)
systemctl --user stop m01-portal.service m01-metrics.service m01-web.service m01-redis.service m01-app-pod.service m01-lost.service >/dev/null 2>&1 || true
rm -f "${QDIR}"/m01-* "${SHOME}/.config/systemd/user/m01-lost.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman pod rm -f m01-app >/dev/null 2>&1 || true
podman rm -f m01-portal m01-metrics m01-pg m01-api m01-broken-126 m01-broken-port m01-lost m01-oom-worker >/dev/null 2>&1 || true
podman secret rm m01_web_sec >/dev/null 2>&1 || true
podman volume rm -f m01-pgvol >/dev/null 2>&1 || true
podman network rm -f m01-cnet >/dev/null 2>&1 || true
run_privileged rm -f /etc/containers/registries.conf.d/50-m01.conf
for p in 18101 18102 18103; do run_privileged firewall-cmd --permanent --remove-port="${p}/tcp" >/dev/null 2>&1 || true; done
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true
podman unshare rm -rf "${WORK}" >/dev/null 2>&1 || rm -rf "${WORK}"
