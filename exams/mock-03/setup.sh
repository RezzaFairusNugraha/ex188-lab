#!/usr/bin/env bash
set -euo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/exam_setup_helper.sh"
bash "${EXAM_DIR}/reset.sh" >/dev/null 2>&1 || true
registry_start_all
SHOME="$(student_home)"
WORK="${SHOME}/workspace/m03"
mkdir -p "${WORK}"

exam_seed_push "${EXAM_BASE_IMAGE}" "${REG_TLS_HOST}/m03/base:1.0"
exam_build_app api-express localhost/m03-api:1.0
exam_build_app webapp-flask localhost/m03-ts-web:1.0
exam_ensure_image "${EXAM_BASE_IMAGE}"
podman run -d --name m03-hotfix "${EXAM_BASE_IMAGE}" sh -c 'echo INITIAL=true > /etc/hotfix.conf && sleep 3600' >/dev/null
sleep 1
podman exec m03-hotfix sh -c 'echo PATCHED=yes >> /etc/hotfix.conf'
exam_build_inline localhost/m03-ts-127:1.0 $'FROM registry.access.redhat.com/ubi10/ubi-minimal:latest\nENTRYPOINT ["/usr/bin/does-not-exist"]'
podman create --name m03-ts-127 localhost/m03-ts-127:1.0 >/dev/null
podman start m03-ts-127 >/dev/null 2>&1 || true
mkdir -p "${WORK}/se-data"
podman run -d --name m03-ts-se -p 18306:8080 -e APP_ENV=production -e CHECK_STORAGE=1 -v "${WORK}/se-data:/var/lib/webapp/data" localhost/m03-ts-web:1.0 >/dev/null
podman run -d --name m03-ts-hc -p 18307:8080 --health-cmd='wget -q -O /dev/null http://127.0.0.1:80/ || exit 1' --health-retries=1 quay.io/nginx/nginx-unprivileged:1.26-alpine >/dev/null
podman run -d --name m03-ts-keeper "${EXAM_BASE_IMAGE}" sleep 3600 >/dev/null
podman network create --subnet 10.89.77.0/24 m03-ts-stale >/dev/null
podman pod create --name m03-ts-pod >/dev/null
cat > "${WORK}/deploy.sh" <<'EOS'
#!/usr/bin/env bash
set -euo pipefail
podman network create --subnet 10.89.77.0/24 m03-ts-net
podman pod create --name m03-ts-pod --network m03-ts-net -p 18308:8080
podman run -d --name m03-ts-cache --pod m03-ts-pod docker.io/library/redis:7-alpine
podman run -d --name m03-ts-web2 --pod m03-ts-pod -e APP_ENV=production -e REDIS_HOST=127.0.0.1 localhost/m03-ts-web:1.0
EOS
chmod 0755 "${WORK}/deploy.sh"
