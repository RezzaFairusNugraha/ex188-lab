#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "03-25"
registry_start_all
SHOME="$(student_home)"
WORK="${SHOME}/workspace/03-25"

systemctl --user stop prod-metrics.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/containers/systemd/prod-metrics.container"
systemctl --user daemon-reload >/dev/null 2>&1 || true
podman rm -f prod-metrics >/dev/null 2>&1 || true
run_privileged firewall-cmd --permanent --remove-port=9325/tcp >/dev/null 2>&1 || true
run_privileged firewall-cmd --reload >/dev/null 2>&1 || true

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
run_privileged mkdir -p "/etc/containers/certs.d/${REG_TLS_HOST}"
run_privileged install -m 0644 "${LAB_CERTS_DIR}/ca.crt" "/etc/containers/certs.d/${REG_TLS_HOST}/ca.crt"
podman build -q -t "${REG_TLS_HOST}/prod/metrics-agent:1.0" "${WORK}/b" >/dev/null
podman push "${REG_TLS_HOST}/prod/metrics-agent:1.0" >/dev/null
podman rmi "${REG_TLS_HOST}/prod/metrics-agent:1.0" >/dev/null 2>&1 || true
run_privileged rm -rf "/etc/containers/certs.d/${REG_TLS_HOST}"
rm -rf "${WORK}"
