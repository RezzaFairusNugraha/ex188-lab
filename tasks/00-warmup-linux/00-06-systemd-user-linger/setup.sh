#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-06"
SUSER="$(student_user)"
SHOME="$(student_home)"
WORK="${SHOME}/workspace/00-06"

systemctl --user disable --now ex188-pulse.service >/dev/null 2>&1 || true
rm -f "${SHOME}/.config/systemd/user/ex188-pulse.service"
mkdir -p "${WORK}" "${SHOME}/.config/systemd/user"

cat > "${WORK}/pulse.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
while true; do
    date -u +"%Y-%m-%dT%H:%M:%SZ pulse-alive" >> "$(dirname "$0")/pulse.log"
    sleep 3
done
EOF
chmod 0755 "${WORK}/pulse.sh"
chown -R "${SUSER}:${SUSER}" "${WORK}" "${SHOME}/.config" 2>/dev/null || true
