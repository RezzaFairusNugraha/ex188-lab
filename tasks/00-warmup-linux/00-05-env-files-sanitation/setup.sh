#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-05"
seed_var "00-05" TARGET_SITE "dc-west" "dc-west" "dc-north" "eu-central" "ap-south"

SHOME="/home/$(student_user)"
WORK="${SHOME}/workspace/00-05"
mkdir -p "${WORK}" "${SHOME}/.bashrc.d"
rm -f "${SHOME}/.bashrc.d/ex188-profile.sh" "${WORK}/container.env"

cat > "${WORK}/legacy-vars.sh" <<'EOF'
# Legacy shell environment script
export APP_PORT="8080"
export APP_ENV='production'

# Logging settings
LOG_LEVEL="info"
export CACHE_TTL=120
EOF
chown -R "$(student_user):$(student_user)" "${WORK}" "${SHOME}/.bashrc.d" 2>/dev/null || true
