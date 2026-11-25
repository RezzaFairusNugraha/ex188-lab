#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "05-12"
registry_start_all
WORK="$(student_home)/workspace/05-12"
podman rm -f catalog-svc >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}"

podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_INSECURE_HOST}/inventory/catalog-svc:2.1.0"
podman push --tls-verify=false "${REG_INSECURE_HOST}/inventory/catalog-svc:2.1.0" >/dev/null
podman rmi "${REG_INSECURE_HOST}/inventory/catalog-svc:2.1.0" >/dev/null 2>&1 || true

cat > "${WORK}/deploy.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
podman run -d --name catalog-svc --tls-verify=false inventory/catalog-svc:v2.1 sleep 3600
EOF
chmod 0755 "${WORK}/deploy.sh"
