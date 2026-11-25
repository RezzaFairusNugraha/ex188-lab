#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
podman rm -f billing-api-0503 >/dev/null 2>&1 || true
podman secret rm billing_tok_0503 >/dev/null 2>&1 || true
podman rmi -f localhost/ts-api-0503:1.0 >/dev/null 2>&1 || true
