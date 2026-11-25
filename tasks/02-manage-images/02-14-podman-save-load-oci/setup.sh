#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "02-14"
WORK="$(student_home)/workspace/02-14"
rm -rf "${WORK}"
mkdir -p "${WORK}/src"

cat > "${WORK}/src/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
ENV BACKUP_TIER=gold
USER 1001
CMD ["sh", "-c", "echo $BACKUP_TIER"]
EOF
podman build -q -t localhost/backup-demo:1.0 "${WORK}/src" >/dev/null
rm -rf "${WORK}/src"
