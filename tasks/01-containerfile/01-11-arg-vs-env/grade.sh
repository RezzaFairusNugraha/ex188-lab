#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "01-11"
PROD_REL="${PROD_REL:-2.4.0}"

assert_image_exists 2 "localhost/release-demo:default"
assert_image_exists 2 "localhost/release-demo:prod"

check_cmd 3 "default image has /etc/build-channel=dev and APP_RELEASE=1.0.0" \
    "default image values do not match defaults (dev / 1.0.0)" \
    bash -c "podman run --rm localhost/release-demo:default sh -c '[[ \"\$(cat /etc/build-channel)\" == \"dev\" && \"\${APP_RELEASE}\" == \"1.0.0\" ]]'"

check_cmd 4 "prod image has /etc/build-channel=production and APP_RELEASE=${PROD_REL}" \
    "prod image did not apply --build-arg overrides" \
    bash -c "podman run --rm localhost/release-demo:prod sh -c '[[ \"\$(cat /etc/build-channel)\" == \"production\" && \"\${APP_RELEASE}\" == \"${PROD_REL}\" ]]'"

check_cmd 4 "BUILD_CHANNEL does NOT leak into runtime environment of prod image" \
    "BUILD_CHANNEL was found in runtime env (should be ARG only, not ENV)" \
    bash -c "! podman run --rm localhost/release-demo:prod env | grep -q '^BUILD_CHANNEL='"

grade_finish
