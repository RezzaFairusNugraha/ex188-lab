#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "03-06"

assert_container_running 3 "quota-worker"
check_cmd 4 "Memory limit equals 268435456 bytes (256m) and MemorySwap equals 268435456" \
    "HostConfig.Memory or HostConfig.MemorySwap does not equal 268435456" \
    bash -c "[[ \"\$(podman inspect --format '{{.HostConfig.Memory}}:{{.HostConfig.MemorySwap}}' quota-worker)\" == '268435456:268435456' ]]"
check_cmd 4 "CPU quota equals 0.5 CPUs (NanoCpus == 500000000 or CpuQuota == 50000)" \
    "CPU quota on quota-worker is not 0.5 CPUs" \
    bash -c "podman inspect --format '{{.HostConfig.NanoCpus}}:{{.HostConfig.CpuQuota}}' quota-worker | grep -Eq '500000000:|:50000'"
check_cmd 4 "PidsLimit equals 64" \
    "HostConfig.PidsLimit is not 64" \
    bash -c "[[ \"\$(podman inspect --format '{{.HostConfig.PidsLimit}}' quota-worker)\" == '64' ]]"

grade_finish
