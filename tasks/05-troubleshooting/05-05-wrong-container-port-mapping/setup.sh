#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-05"
WORK="$(student_home)/workspace/05-05"
podman rm -f metrics-broken-port >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}/b"

cp -a "${LAB_APPS_DIR}/metrics-go/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM docker.io/library/golang:1.22 AS builder
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/metrics-agent .
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
COPY --from=builder --chmod=0755 /out/metrics-agent /usr/local/bin/metrics-agent
USER 1001
ENTRYPOINT ["/usr/local/bin/metrics-agent"]
EOF
podman build -q -t localhost/ts-metrics-0505:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}"

# Bug: app listens on METRICS_PORT=9095, but -p mapped 9505:80!
podman run -d --name metrics-broken-port -p 9505:80 -e METRICS_PORT=9095 -e SERVICE_NAME=ts-0505 localhost/ts-metrics-0505:1.0 >/dev/null
