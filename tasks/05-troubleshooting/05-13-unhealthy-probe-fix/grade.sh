#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-13"

assert_container_running 4 "portal-unhealthy"
assert_container_port 3 "portal-unhealthy" "8080/tcp" "8513"
podman healthcheck run portal-unhealthy >/dev/null 2>&1 || true
assert_container_healthy 8 "portal-unhealthy"

grade_finish
