#!/usr/bin/env bash
set -euo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/registry.sh"

bash "${EXAM_DIR}/reset.sh" >/dev/null 2>&1 || true
registry_start_all
SHOME="$(student_home)"
WORK="${SHOME}/workspace/m01"
mkdir -p "${WORK}/broken-126"

# Seed base image in :5000 and repo in :5444
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_INSECURE_HOST}/m01-seed/ubi-base:1.0"
podman push --remove-signatures --tls-verify=false "${REG_INSECURE_HOST}/m01-seed/ubi-base:1.0" >/dev/null
podman rmi "${REG_INSECURE_HOST}/m01-seed/ubi-base:1.0" >/dev/null 2>&1 || true

TMP_A="$(mktemp)"
run_privileged mkdir -p "/etc/containers/certs.d/${REG_AUTH_HOST}"
run_privileged install -m 0644 "${LAB_CERTS_DIR}/ca.crt" "/etc/containers/certs.d/${REG_AUTH_HOST}/ca.crt"
podman login --authfile "${TMP_A}" -u student -p redhat123 "${REG_AUTH_HOST}" >/dev/null
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_AUTH_HOST}/seed/catalog-check:1.0"
podman push --remove-signatures --authfile "${TMP_A}" "${REG_AUTH_HOST}/seed/catalog-check:1.0" >/dev/null
podman rmi "${REG_AUTH_HOST}/seed/catalog-check:1.0" >/dev/null 2>&1 || true
rm -f "${TMP_A}"
run_privileged rm -rf "/etc/containers/certs.d/${REG_AUTH_HOST}" "/etc/containers/certs.d/${REG_TLS_HOST}"

# Broken 18: exit 126
cat > "${WORK}/broken-126/run.sh" <<'EOF'
#!/bin/sh
exec sleep 3600
EOF
chmod 0644 "${WORK}/broken-126/run.sh"
cat > "${WORK}/broken-126/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
COPY run.sh /usr/local/bin/run.sh
USER 1001
ENTRYPOINT ["/usr/local/bin/run.sh"]
EOF
podman build -q -t localhost/m01-b126:1.0 "${WORK}/broken-126" >/dev/null
podman create --name m01-broken-126 localhost/m01-b126:1.0 >/dev/null

# Broken 19: wrong port
podman run -d --name m01-broken-port -p 18105:80 quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null

# Broken 20: misplaced Quadlet
mkdir -p "${SHOME}/.config/systemd/user"
cat > "${SHOME}/.config/systemd/user/m01-lost.container" <<'EOF'
[Container]
Image=quay.io/nginx/nginx-unprivileged:1.26-alpine
ContainerName=m01-lost
Ports=18106:8080

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

# Broken 21: OOM 137
mkdir -p "${WORK}/oom"
cat > "${WORK}/oom/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && dnf clean all
USER 1001
CMD ["python3", "-u", "-c", "x = bytearray(35*1024*1024); print('OOM_FIXED'); import time; time.sleep(3600)"]
EOF
podman build -q -t localhost/m01-oom:1.0 "${WORK}/oom" >/dev/null
rm -rf "${WORK}/oom"
podman run -d --name m01-oom-worker --memory 10m --memory-swap 10m localhost/m01-oom:1.0 >/dev/null 2>&1 || true

# Broken 22: dangling image
mkdir -p "${WORK}/dng"
printf 'FROM registry.access.redhat.com/ubi10/ubi-minimal:latest\nRUN echo d1 > /etc/d\n' > "${WORK}/dng/Containerfile"
podman build -q -t localhost/m01-dng-tmp:1.0 "${WORK}/dng" >/dev/null
printf 'FROM registry.access.redhat.com/ubi10/ubi-minimal:latest\nRUN echo d2 > /etc/d\n' > "${WORK}/dng/Containerfile"
podman build -q -t localhost/m01-dng-tmp:1.0 "${WORK}/dng" >/dev/null
rm -rf "${WORK}/dng"
