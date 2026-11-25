#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "05-14"
podman rm -f orders-db >/dev/null 2>&1 || true
podman volume rm -f orders-pgvol >/dev/null 2>&1 || true
podman volume create orders-pgvol >/dev/null

# Bug: mounted at /var/lib/postgresql/data instead of /var/lib/pgsql/data!
podman run -d --name orders-db \
    -e POSTGRESQL_USER=ord -e POSTGRESQL_PASSWORD=ordpass -e POSTGRESQL_DATABASE=orddb \
    -v orders-pgvol:/var/lib/postgresql/data \
    quay.io/sclorg/postgresql-16-c10s:latest >/dev/null
