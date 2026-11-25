#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-02"
mkdir -p /var/tmp/ex188-00-02 "/home/$(student_user)/workspace/00-02"
cat > /var/tmp/ex188-00-02/gateway.log <<'EOF'
2026-05-01T10:00:01Z INFO  GET /index.html 200
2026-05-01T10:00:02Z ERROR GET /healthz 503 upstream-warmup
2026-05-01T10:00:04Z ERROR POST /api/v1/orders 500 db-timeout-01
2026-05-01T10:00:05Z INFO  GET /healthz 200
2026-05-01T10:00:07Z CRITICAL AUTH /login token-signer-offline
2026-05-01T10:00:09Z ERROR GET /api/v1/items 502 bad-gateway-02
2026-05-01T10:00:10Z CRITICAL GET /healthz 500 readiness-flap
2026-05-01T10:00:12Z ERROR PUT /api/v1/cart 504 gateway-timeout-03
2026-05-01T10:00:15Z CRITICAL STORAGE /var/lib/app disk-readonly-04
EOF
chown -R "$(student_user):$(student_user)" "/home/$(student_user)/workspace/00-02" 2>/dev/null || true
