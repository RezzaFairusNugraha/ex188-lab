#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "03-14"
WORK="$(student_home)/workspace/03-14"
rm -rf "${WORK}"
mkdir -p "${WORK}"
printf '<h1>Updated Live via podman cp</h1>\n' > "${WORK}/new-index.html"

podman rm -f portal-live >/dev/null 2>&1 || true
podman run -d --name portal-live -p 8314:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null
sleep 1
podman exec portal-live sh -c 'echo "DIAG_OK_0314" > /tmp/diag-report.txt'
