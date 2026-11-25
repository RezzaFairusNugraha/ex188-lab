#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-20"
WORK="$(student_home)/workspace/05-20"
podman rm -f batch-mem-0520 >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}/b"

cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && dnf clean all
USER 1001
CMD ["python3", "-u", "-c", "buf = bytearray(40 * 1024 * 1024); print('BATCH_READY'); import time; time.sleep(3600)"]
EOF
podman build -q -t localhost/ts-mem-0520:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

# Set 12m limit -> guaranteed OOM kill (137)!
podman run -d --name batch-mem-0520 --memory 12m --memory-swap 12m localhost/ts-mem-0520:1.0 >/dev/null 2>&1 || true
sleep 2
