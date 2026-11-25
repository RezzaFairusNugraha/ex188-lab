#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-03"
WORK="$(student_home)/workspace/04-03"
rm -rf "${WORK}"
mkdir -p "${WORK}/b"
podman rm -f sec-mount-api >/dev/null 2>&1 || true
podman secret rm nw_token >/dev/null 2>&1 || true

printf 'TokenMount_4491' > "${WORK}/token.src"
cp -a "${LAB_APPS_DIR}/api-express/." "${WORK}/b/"
cat > "${WORK}/b/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y nodejs && mkdir -p /opt/api-express /var/lib/api-express/audit && chown -R 1001:0 /opt/api-express /var/lib/api-express && chmod -R g=u /var/lib/api-express && dnf clean all
WORKDIR /opt/api-express
COPY --chown=1001:0 package.json server.js /opt/api-express/
COPY --chown=1001:0 config /opt/api-express/config
USER 1001
CMD ["node", "server.js"]
EOF
podman build -q -t localhost/api-0403:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"
