#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "02-18"
WORK="$(student_home)/workspace/02-18"
rm -rf "${WORK}"
mkdir -p "${WORK}/tmp_cf"
podman rmi -f localhost/mystery-{alpha,beta,gamma}:1.0 >/dev/null 2>&1 || true

# 1. export/import -> mystery-alpha:1.0 (1 layer, history comment "imported from tarball", empty Config.Env except PATH)
podman run --name tmp-0218-exp registry.access.redhat.com/ubi10/ubi-minimal:latest sh -c 'echo exp > /etc/m'
podman export -o "${WORK}/exp.tar" tmp-0218-exp
podman rm -f tmp-0218-exp >/dev/null
podman import "${WORK}/exp.tar" localhost/mystery-alpha:1.0 >/dev/null
rm -f "${WORK}/exp.tar"

# 2. commit -> mystery-beta:1.0 (base layers + 1 committed layer without Containerfile STEP history, Author="forensic-commit")
podman run --name tmp-0218-cmt registry.access.redhat.com/ubi10/ubi-minimal:latest sh -c 'echo cmt > /etc/m'
podman commit -m "manual-live-container-commit" tmp-0218-cmt localhost/mystery-beta:1.0 >/dev/null
podman rm -f tmp-0218-cmt >/dev/null

# 3. Containerfile + save/load -> mystery-gamma:1.0 (preserves "/bin/sh -c #(nop) ENV ..." Containerfile history)
cat > "${WORK}/tmp_cf/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
ENV BUILT_BY_CONTAINERFILE=yes
RUN echo cf > /etc/m
USER 1001
EOF
podman build -q -t localhost/mystery-gamma:1.0 "${WORK}/tmp_cf" >/dev/null
podman save -o "${WORK}/sv.tar" localhost/mystery-gamma:1.0
podman rmi localhost/mystery-gamma:1.0 >/dev/null 2>&1 || true
podman load -i "${WORK}/sv.tar" >/dev/null
rm -rf "${WORK}/tmp_cf" "${WORK}/sv.tar"
