#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "04-20"
WORK="$(student_home)/workspace/04-20"
podman rm -f rotatable-api >/dev/null 2>&1 || true
podman secret rm api_rot_secret >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}/b"

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
podman build -q -t localhost/api-0420:1.0 "${WORK}/b" >/dev/null
rm -rf "${WORK}/b"

printf '[{"sku":"R1","name":"One","stock":1}]\n' > "${WORK}/catalog.json"
chmod 0644 "${WORK}/catalog.json"
printf 'OldExpiredToken' | podman secret create api_rot_secret - >/dev/null
podman run -d --name rotatable-api -p 3420:3000 -e AUTH_REQUIRED=true \
    -v "${WORK}/catalog.json:/etc/api-express/catalog.json:ro,Z" \
    --secret api_rot_secret,target=/run/secrets/api_token,uid=1001,mode=0400 \
    localhost/api-0420:1.0 >/dev/null
