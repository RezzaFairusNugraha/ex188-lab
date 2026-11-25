#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
SHOME="$(student_home)"
systemctl --user stop journal-web.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/journal-web.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f journal-web >/dev/null 2>&1 || true
podman rmi -f localhost/webapp-0324:1.0 >/dev/null 2>&1 || true
run_privileged rm -rf /srv/student-journal
