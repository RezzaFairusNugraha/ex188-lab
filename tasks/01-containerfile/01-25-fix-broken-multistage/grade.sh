#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-25"
WORK="$(student_home)/workspace/01-25"
IMG="localhost/metrics-secure:2.0"

assert_file_exists 2 "${WORK}/scrape-token.secret" "Host scrape-token.secret preserved"
assert_image_exists 2 "${IMG}"
assert_image_user 3 "${IMG}" "1001"
check_cmd 5 "Final image contains /usr/local/bin/metrics-agent and ZERO leaked source or .secret files" \
    "main.go or scrape-token.secret leaked into localhost/metrics-secure:2.0" \
    bash -c "podman run --rm --entrypoint test '${IMG}' -x /usr/local/bin/metrics-agent && ! podman run --rm --entrypoint sh '${IMG}' -c 'find / -name \"*secret*\" -o -name \"main.go\" 2>/dev/null | grep -E \"main\\.go|scrape-token\"'"
assert_container_running 3 "metrics-prod"
check_cmd 5 "/metrics enforces token (401 without token, 200 with ScrapeGuard_8821)" \
    "/metrics did not enforce scrape_token secret properly" \
    bash -c "[[ \"\$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:9125/metrics)\" == '401' ]] && curl -fsS 'http://127.0.0.1:9125/metrics?token=ScrapeGuard_8821' | grep -q 'ex188_up'"

grade_finish
