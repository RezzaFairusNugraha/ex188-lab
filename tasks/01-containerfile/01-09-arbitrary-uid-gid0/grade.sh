#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-09"
IMG="localhost/webapp-ocp-ready:1.0"

assert_image_exists 4 "${IMG}"
assert_image_user 4 "${IMG}" "1001"
check_cmd 4 "/var/lib/webapp/data has group owner 0 and group-write bit enabled" \
    "/var/lib/webapp/data lacks GID 0 ownership or g=u write permission" \
    bash -c "podman run --rm --entrypoint stat '${IMG}' -c '%g:%A' /var/lib/webapp/data | grep -Eq '^0:d....w'"

podman rm -f grade-01-09 >/dev/null 2>&1 || true
if podman run -d --name grade-01-09 --user 42420:0 -p 18809:8080 "${IMG}" >/dev/null 2>&1 && sleep 2 \
    && curl -fsS http://127.0.0.1:18809/healthz | grep -q '"status": *"ok"' \
    && curl -fsS -X POST "http://127.0.0.1:18809/entries?msg=ocp-uid-ok" | grep -q 'ocp-uid-ok'; then
    pass_check 8 "Container succeeds on /healthz and POST /entries when forced to random --user 42420:0"
else
    fail_check 8 "Arbitrary UID runtime check" "container failed healthz or write test when run with --user 42420:0"
fi
podman rm -f grade-01-09 >/dev/null 2>&1 || true

grade_finish
