#!/usr/bin/env bash
set -euo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/exam_setup_helper.sh"
bash "${EXAM_DIR}/reset.sh" >/dev/null 2>&1 || true
registry_start_all
SHOME="$(student_home)"
WORK="${SHOME}/workspace/m04"
mkdir -p "${WORK}"

exam_seed_push "${EXAM_BASE_IMAGE}" "${REG_INSECURE_HOST}/m04-seed/tool:2.0"
exam_build_app webapp-flask localhost/m04-ts-web:1.0
printf 'M04_BuildKey_DoNotBake_01\n' > "${WORK}/build.key"
mkdir -p "${WORK}/secret-build" "${WORK}/journal" "${WORK}/compose"
chmod 0755 "${WORK}/journal"
podman network create m04-ts-net >/dev/null
podman volume create m04-ts-pgvol >/dev/null
podman run -d --name m04-ts-db --network m04-ts-net -v m04-ts-pgvol:/var/lib/pgsql/data -e POSTGRESQL_USER=u -e POSTGRESQL_PASSWORD=p -e POSTGRESQL_DATABASE=d quay.io/sclorg/postgresql-16-c10s:latest >/dev/null
podman run -d --name m04-ts-app -p 18406:8080 -e APP_ENV=production -e DB_HOST=postgres-typo localhost/m04-ts-web:1.0 >/dev/null
podman run -d --name m04-ts-uid -p 18405:8080 -e APP_ENV=production -v "${WORK}/journal:/var/lib/webapp/data:Z" localhost/m04-ts-web:1.0 >/dev/null
mkdir -p "${SHOME}/.config/systemd/user"
cat > "${SHOME}/.config/containers/systemd-m04-lost.tmp" <<'EOS'
[Containers]
Image=quay.io/nginx/nginx-unprivileged:1.26-alpine
ContainerName=m04-ts-lost
Ports=18407:8080
[Install]
WantedBy=multi-user.target
EOS
mv "${SHOME}/.config/containers/systemd-m04-lost.tmp" "${SHOME}/.config/systemd/user/m04-ts-lost.container"
exam_build_inline localhost/m04-ts-oom:1.0 $'FROM registry.access.redhat.com/ubi10/ubi:latest\nRUN dnf install -y python3 && dnf clean all\nUSER 1001\nCMD ["python3","-u","-c","x=bytearray(40*1024*1024);print(1);import time;time.sleep(3600)"]'
podman run -d --name m04-ts-oom --memory 10m --memory-swap 10m localhost/m04-ts-oom:1.0 >/dev/null 2>&1 || true
cat > "${WORK}/deploy.sh" <<'EOS'
#!/usr/bin/env bash
set -euo pipefail
podman run -d --name m04-ts-deploy m04-seed/tool:v2.0 sleep 3600
EOS
chmod 0755 "${WORK}/deploy.sh"
