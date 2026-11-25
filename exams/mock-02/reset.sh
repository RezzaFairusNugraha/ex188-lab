#!/usr/bin/env bash
set -euo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
SHOME="$(student_home)"
QDIR="${SHOME}/.config/containers/systemd"
WORK="${SHOME}/workspace/m02"

systemctl --user stop m02-lowedge.service m02-api.service m02-kube.service m02-net-network.service m02-audit-volume.service >/dev/null 2>&1 || true
run_privileged systemctl stop m02-sys-worker.service >/dev/null 2>&1 || true
rm -f "${QDIR}"/m02-*
run_privileged rm -f /etc/containers/systemd/m02-sys-worker.container /etc/sysctl.d/90-m02-lowport.conf /etc/containers/registries.conf.d/60-m02-mirror.conf
systemctl --user daemon-reload >/dev/null 2>&1 || true
run_privileged systemctl daemon-reload
run_privileged sysctl -w net.ipv4.ip_unprivileged_port_start=1024 >/dev/null
podman pod rm -f m02-kpod m02-fixme-pod >/dev/null 2>&1 || true
podman rm -f m02-lowedge m02-api m02-selinux-fail m02-bad-hc m02-db-loss >/dev/null 2>&1 || true
run_privileged podman rm -f m02-sys-worker >/dev/null 2>&1 || true
podman secret rm m02_api_tok >/dev/null 2>&1 || true
podman volume rm -f m02-audit m02-pgvol >/dev/null 2>&1 || true
podman network rm -f m02-net >/dev/null 2>&1 || true
for p in 820 18201 18202; do run_privileged firewall-cmd --permanent --remove-port="${p}/tcp" >/dev/null 2>&1 || true; done
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true
podman unshare rm -rf "${WORK}" >/dev/null 2>&1 || rm -rf "${WORK}"
