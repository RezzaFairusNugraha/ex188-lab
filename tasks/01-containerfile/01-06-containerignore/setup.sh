#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-06"
WORK="$(student_home)/workspace/01-06"
rm -rf "${WORK}"
mkdir -p "${WORK}/.git" "${WORK}/config"

printf 'ref: refs/heads/main\n' > "${WORK}/.git/HEAD"
printf 'DB_PASS=SuperSecretLeak99\n' > "${WORK}/.env.secret"
printf 'verbose trace dump\n' > "${WORK}/debug.log"
printf 'old scratch\n' > "${WORK}/notes.bak"
printf '{"port": 8080}\n' > "${WORK}/config/default.json"
printf 'print("clean-context-ok")\n' > "${WORK}/service.py"

cat > "${WORK}/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
WORKDIR /opt/service
COPY . /opt/service/
USER 1001
EOF
podman rmi -f localhost/clean-context:1.0 >/dev/null 2>&1 || true
