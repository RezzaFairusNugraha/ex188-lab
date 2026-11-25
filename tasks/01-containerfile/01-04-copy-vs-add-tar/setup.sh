#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-04"
WORK="$(student_home)/workspace/01-04"
rm -rf "${WORK}"
mkdir -p "${WORK}/tmp_site" "${WORK}/tmp_bak"

printf '<h1>Extracted by ADD</h1>\n' > "${WORK}/tmp_site/index.html"
printf 'body { color: #22c55e; }\n' > "${WORK}/tmp_site/app.css"
tar -czf "${WORK}/site-assets.tar.gz" -C "${WORK}/tmp_site" .

printf 'raw-backup-payload\n' > "${WORK}/tmp_bak/data.txt"
tar -czf "${WORK}/release-backup.tar.gz" -C "${WORK}/tmp_bak" .
rm -rf "${WORK}/tmp_site" "${WORK}/tmp_bak"
podman rmi -f localhost/portal-static:1.0 >/dev/null 2>&1 || true
