#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-01"
IMAGE_NAME="${IMAGE_NAME:-ubi10-httpd}"
IMAGE_TAG="${IMAGE_TAG:-1.0}"
IMG="localhost/${IMAGE_NAME}:${IMAGE_TAG}"
WORK="$(student_home)/workspace/01-01"

assert_file_exists 2 "${WORK}/Containerfile" "Containerfile exists (and no Dockerfile used)"
check_cmd 1 "No Dockerfile present in build directory" "found prohibited Dockerfile; use Containerfile" \
    bash -c "[[ ! -f '${WORK}/Dockerfile' ]]"
assert_image_exists 3 "${IMG}"
check_cmd 2 "Image exposes port 80/tcp" "Config.ExposedPorts missing 80/tcp" \
    bash -c "podman image inspect --format '{{json .Config.ExposedPorts}}' '${IMG}' | grep -q '80/tcp'"
check_cmd 2 "Image contains /var/www/html/index.html and exec-form CMD" \
    "index.html missing or CMD not configured for httpd -D FOREGROUND" \
    bash -c "podman run --rm --entrypoint cat '${IMG}' /var/www/html/index.html | grep -q 'Welcome to UBI10 HTTPD' && podman image inspect --format '{{json .Config.Cmd}}' '${IMG}' | grep -q 'FOREGROUND'"

grade_finish
