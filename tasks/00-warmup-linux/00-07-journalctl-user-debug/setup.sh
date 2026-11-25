#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-07"
seed_var "00-07" DIAG_CODE "ERR_SPOOL_409" "ERR_SPOOL_409" "ERR_SPOOL_512" "ERR_SPOOL_731"

SHOME="$(student_home)"
WORK="${SHOME}/workspace/00-07"
systemctl --user stop ex188-spoolcheck.service >/dev/null 2>&1 || true
rm -rf "${WORK}"
mkdir -p "${WORK}" "${SHOME}/.config/systemd/user"

cat > "${WORK}/spoolcheck.sh" <<EOF
#!/usr/bin/env bash
set -euo pipefail
REQUIRED_DIR="${WORK}/incoming-jobs"
if [[ ! -d "\${REQUIRED_DIR}" ]]; then
    echo "FATAL: missing directory \${REQUIRED_DIR} | DIAG_TOKEN=${DIAG_CODE}" >&2
    exit 1
fi
echo "INFO: spool directory verified"
while true; do sleep 5; done
EOF
chmod 0755 "${WORK}/spoolcheck.sh"

cat > "${SHOME}/.config/systemd/user/ex188-spoolcheck.service" <<EOF
[Unit]
Description=EX188 Spool Directory Validator

[Service]
ExecStart=${WORK}/spoolcheck.sh
Restart=no
EOF

systemctl --user daemon-reload
systemctl --user start ex188-spoolcheck.service >/dev/null 2>&1 || true
