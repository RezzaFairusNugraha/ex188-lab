#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-25"
WORK="$(student_home)/workspace/01-25"
rm -rf "${WORK}"
mkdir -p "${WORK}"
cp -a "${LAB_APPS_DIR}/metrics-go/." "${WORK}/"
printf 'ScrapeGuard_8821\n' > "${WORK}/scrape-token.secret"

cat > "${WORK}/Containerfile" <<'EOF'
FROM docker.io/library/golang:1.22 AS buildstage
WORKDIR /src
COPY . /src/
RUN go build -o /tmp/metrics .

FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
COPY --from=buildstage /src /app
EXPOSE 9090
ENTRYPOINT /usr/local/bin/metrics-agent
EOF

podman rm -f metrics-prod >/dev/null 2>&1 || true
podman secret rm metrics_scrape_tok >/dev/null 2>&1 || true
podman rmi -f localhost/metrics-secure:2.0 >/dev/null 2>&1 || true
