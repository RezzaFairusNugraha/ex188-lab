#!/usr/bin/env bash
set -euo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/exam_setup_helper.sh"
bash "${EXAM_DIR}/reset.sh" >/dev/null 2>&1 || true
registry_start_all
SHOME="$(student_home)"
WORK="${SHOME}/workspace/m05"
mkdir -p "${WORK}"

exam_seed_push "${EXAM_BASE_IMAGE}" "${REG_TLS_HOST}/m05/core:1.0"
exam_build_app api-express localhost/m05-prebuilt-api:1.0
exam_ensure_image "${EXAM_BASE_IMAGE}"
podman push --remove-signatures -q "${EXAM_BASE_IMAGE}" "dir:${WORK}/seed-dir" >/dev/null 2>&1 || { mkdir -p "${WORK}/seed-dir"; podman push --remove-signatures -q "${EXAM_BASE_IMAGE}" "dir:${WORK}/seed-dir" >/dev/null; }
podman push --remove-signatures -q "${EXAM_BASE_IMAGE}" "oci-archive:${WORK}/seed-oci.tar:localhost/m05-seed:1.0" >/dev/null
podman run --name m05-legacybox "${EXAM_BASE_IMAGE}" sh -c 'echo stamp-m05 > /etc/stamp' >/dev/null
podman run -d --name m05-hotfix "${EXAM_BASE_IMAGE}" sh -c 'echo INITIAL=true > /etc/hotfix.conf && sleep 3600' >/dev/null
sleep 1
podman exec m05-hotfix sh -c 'echo PATCHED=yes >> /etc/hotfix.conf'
mkdir -p "${WORK}/ts126" "${WORK}/compose"
printf '#!/bin/sh\nexec sleep 3600\n' > "${WORK}/ts126/run.sh"
chmod 0644 "${WORK}/ts126/run.sh"
printf 'FROM registry.access.redhat.com/ubi10/ubi-minimal:latest\nCOPY run.sh /usr/local/bin/run.sh\nUSER 1001\nENTRYPOINT ["/usr/local/bin/run.sh"]\n' > "${WORK}/ts126/Containerfile"
podman build -q -t localhost/m05-ts-126:1.0 "${WORK}/ts126" >/dev/null
podman create --name m05-ts-126 localhost/m05-ts-126:1.0 >/dev/null
exam_build_app webapp-flask localhost/m05-ts-web:1.0
podman network create m05-ts-net >/dev/null
podman run -d --name m05-ts-db --network m05-ts-net -e POSTGRESQL_USER=u -e POSTGRESQL_PASSWORD=p -e POSTGRESQL_DATABASE=d quay.io/sclorg/postgresql-16-c10s:latest >/dev/null
podman run -d --name m05-ts-api -p 18507:8080 -e APP_ENV=production -e DB_HOST=m05-ts-db localhost/m05-ts-web:1.0 >/dev/null
mkdir -p "${SHOME}/.config/containers/systemd"
cat > "${SHOME}/.config/containers/systemd/m05-ts-persist.container" <<'EOS'
[Container]
Image=quay.io/nginx/nginx-unprivileged:1.26-alpine
ContainerName=m05-ts-persist
PublishPort=18508:8080
[Service]
Restart=always
[Install]
WantedBy=multi-user.target
EOS
systemctl --user daemon-reload || true
systemctl --user start m05-ts-persist.service || true
podman run -d --name m05-ts-hc -p 18509:8080 --health-cmd='wget -q -O /dev/null http://127.0.0.1:80/ || exit 1' --health-retries=1 quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null
podman network create --subnet 10.89.95.0/24 m05-audit-net >/dev/null
printf 'm05-audit' | podman secret create m05-audit-sec - >/dev/null
podman pod create --name m05-audit-pod --network m05-audit-net >/dev/null
