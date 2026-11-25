#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "01-05"
WORK="$(student_home)/workspace/01-05"
rm -rf "${WORK}"
mkdir -p "${WORK}"

cat > "${WORK}/launcher.sh" <<'EOF'
#!/bin/sh
cat /opt/app/settings.ini
EOF
chmod 0600 "${WORK}/launcher.sh"
printf 'mode=verified\n' > "${WORK}/settings.ini"
chmod 0666 "${WORK}/settings.ini"
podman rmi -f localhost/chown-demo:1.0 >/dev/null 2>&1 || true
