#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"
source "${TASK_DIR}/../../../lib/registry.sh"

seed_init "05-11"
registry_start_all
SHOME="$(student_home)"
podman rm -f sec-scanner >/dev/null 2>&1 || true

run_privileged mkdir -p "/etc/containers/certs.d/${REG_AUTH_HOST}"
run_privileged install -m 0644 "${LAB_CERTS_DIR}/ca.crt" "/etc/containers/certs.d/${REG_AUTH_HOST}/ca.crt"

TMP_A="$(mktemp)"
podman login --authfile "${TMP_A}" -u student -p redhat123 "${REG_AUTH_HOST}" >/dev/null
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest "${REG_AUTH_HOST}/sec/scanner:2.0"
podman push --remove-signatures --authfile "${TMP_A}" "${REG_AUTH_HOST}/sec/scanner:2.0" >/dev/null
podman rmi "${REG_AUTH_HOST}/sec/scanner:2.0" >/dev/null 2>&1 || true
rm -f "${TMP_A}"

# Plant the 2 bugs: blocked = true in ~/.config/containers/registries.conf + wrong base64 token in ~/.config/containers/auth.json!
mkdir -p "${SHOME}/.config/containers"
cat > "${SHOME}/.config/containers/registries.conf" <<'EOF'
unqualified-search-registries = ["registry.access.redhat.com", "quay.io", "docker.io"]

[[registry]]
location = "auth-reg.lab.local:5444"
blocked = true
EOF

cat > "${SHOME}/.config/containers/auth.json" <<'EOF'
{
  "auths": {
    "auth-reg.lab.local:5444": {
      "auth": "c3R1ZGVudDp3cm9uZ3Bhc3N3b3Jk"
    }
  }
}
EOF
