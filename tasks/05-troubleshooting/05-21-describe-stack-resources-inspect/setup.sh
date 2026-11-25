#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-21"
WORK="$(student_home)/workspace/05-21"
podman pod rm -f audit-pod-0521 >/dev/null 2>&1 || true
podman network rm -f audit-net-0521 >/dev/null 2>&1 || true
podman volume rm -f audit-vol-0521 >/dev/null 2>&1 || true
podman secret rm audit-sec-0521 >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}"

podman network create --subnet 10.89.91.0/24 audit-net-0521 >/dev/null
podman volume create audit-vol-0521 >/dev/null
printf 'InventorySec_0521' | podman secret create audit-sec-0521 - >/dev/null
podman pod create --name audit-pod-0521 --network audit-net-0521 >/dev/null
podman run -d --name audit-worker-0521 --pod audit-pod-0521 --user 1009:1009 \
    -v audit-vol-0521:/data --secret audit-sec-0521 \
    registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600 >/dev/null
