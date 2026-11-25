#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-17"
WORK="$(student_home)/workspace/05-17"
podman rm -f prod-keeper junk-crash-1 junk-crash-2 >/dev/null 2>&1 || true
podman volume rm -f prod-keeper-vol orphan-vol-1 orphan-vol-2 >/dev/null 2>&1 || true
podman rmi -f localhost/bloated-junk:old >/dev/null 2>&1 || true

rm -rf "${WORK}"
mkdir -p "${WORK}/b"
podman volume create prod-keeper-vol >/dev/null
podman run -d --name prod-keeper -v prod-keeper-vol:/data registry.access.redhat.com/ubi10/ubi-minimal:latest \
    sh -c 'echo "DO_NOT_LOSE" > /data/keep.txt && sleep 3600' >/dev/null

# Create bloated exited containers + orphan volumes + bloated unused image
podman volume create orphan-vol-1 >/dev/null
podman run --name junk-crash-1 -v orphan-vol-1:/junk registry.access.redhat.com/ubi10/ubi-minimal:latest \
    sh -c 'dd if=/dev/zero of=/junk/dump1.bin bs=1M count=50 2>/dev/null; dd if=/dev/zero of=/var/tmp/core1.bin bs=1M count=50 2>/dev/null'
podman rm -f junk-crash-1 >/dev/null # leaves orphan-vol-1 with 50MB!
podman run --name junk-crash-2 registry.access.redhat.com/ubi10/ubi-minimal:latest \
    sh -c 'dd if=/dev/zero of=/var/tmp/core2.bin bs=1M count=50 2>/dev/null'

cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN dd if=/dev/zero of=/var/tmp/bloat.bin bs=1M count=60 2>/dev/null
EOF
podman build -q -t localhost/bloated-junk:old "${WORK}/b" >/dev/null
rm -rf "${WORK}"
