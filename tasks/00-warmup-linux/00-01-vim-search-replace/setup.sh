#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-01"
seed_port "00-01" TARGET_PORT 8080 18080 18999

WORK="/home/$(student_user)/workspace/00-01"
mkdir -p "${WORK}"
cat > "${WORK}/service-draft.yaml" <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: portal-preview
spec:
  DEPRECATED_SETTING: remove-me-alpha
  containers:
    - name: web
      image: docker.io/legacycorp/httpd-24:latest
      ports:
        - containerPort: 80
    - name: sidecar
      image: docker.io/legacycorp/ubi-minimal:latest
      DEPRECATED_SETTING: remove-me-beta
      ports:
        - containerPort: 80
EOF
chown -R "$(student_user):$(student_user)" "${WORK}" 2>/dev/null || true
