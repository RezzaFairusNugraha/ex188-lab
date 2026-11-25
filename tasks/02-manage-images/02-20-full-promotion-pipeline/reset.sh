#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
run_privileged rm -f /etc/containers/registries.conf.d/70-dev.conf
run_privileged rm -rf /etc/containers/certs.d/secure-reg.lab.local:5443 /etc/containers/certs.d/auth-reg.lab.local:5444
rm -f "$(student_home)/.config/containers/auth.json"
podman rmi -f registry.lab.local:5000/dev/payment-svc:0.9-rc2 \
    secure-reg.lab.local:5443/qa/payment-svc:1.0.0 \
    auth-reg.lab.local:5444/prod/payment-svc:{1.0.0,latest} >/dev/null 2>&1 || true
rm -rf "$(student_home)/workspace/02-20"
