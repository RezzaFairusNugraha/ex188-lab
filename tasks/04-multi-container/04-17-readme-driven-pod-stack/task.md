# Task 04-17: Deploying Pre-Written webapp-flask + DB + Cache Stack Strictly from README.md

## Scenario
Read `/home/student/apps/webapp-flask/README.md` carefully. Without modifying any Python code, deploy `webapp-flask` together with **both** upstream dependencies (PostgreSQL 16 and Redis 7), secret signing material, persistent storage, and custom config on a custom network `readme-net`.

## Requirements
1. Build `localhost/acme-full:1.0` from `/home/student/apps/webapp-flask/` (copied into `/home/student/workspace/04-17/build/`) as `USER 1001`.
2. Create custom network `readme-net`, named volume `acme-notes-vol`, named volume `acme-db-vol`, and Podman secret `acme_sign_key` (`SignKey_0417`).
3. Start `acme-redis` (`docker.io/library/redis:7-alpine`) and `acme-pg` (`quay.io/sclorg/postgresql-16-c10s:latest` with `acme-db-vol` at `/var/lib/pgsql/data`) on `readme-net`.
4. Start `acme-app` on `readme-net` publishing host port `8417` (`${HOST_PORT}` if `--seed` is active) -> `8080`, mounting `acme-notes-vol` at `/var/lib/webapp/data`, mounting `acme_sign_key` so `webapp-flask` loads it as a file secret, setting `REQUIRE_STRICT_ENV=1`, `REQUIRE_SECRET=1`, `CHECK_STORAGE=1`, `APP_ENV=production`, and wiring both upstream hostnames documented in `README.md`.
5. Verify `GET /healthz` returns `200 OK` with `"redis"`, `"database"`, and `"storage": "writable"`!
