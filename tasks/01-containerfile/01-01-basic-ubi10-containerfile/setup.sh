#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-01"
seed_var "01-01" IMAGE_NAME "ubi10-httpd" "ubi10-httpd" "portal-httpd" "edge-httpd"
seed_var "01-01" IMAGE_TAG "1.0" "1.0" "1.1" "2.0"

WORK="$(student_home)/workspace/01-01"
rm -rf "${WORK}"
mkdir -p "${WORK}"
printf '<h1>Welcome to UBI10 HTTPD</h1>\n' > "${WORK}/index.html"
podman rmi -f "localhost/${IMAGE_NAME}:${IMAGE_TAG}" >/dev/null 2>&1 || true
