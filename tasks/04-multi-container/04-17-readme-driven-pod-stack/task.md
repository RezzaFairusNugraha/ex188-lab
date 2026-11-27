# Task 04-17: Multi-Service Application Deployment Strictly from Vendor Documentation

## Objective
The `webapp-flask` source files and `README.md` have been pre-staged in `/home/student/workspace/04-17/build/`. Read `README.md` to wire the web application to PostgreSQL 16, Redis 7, a Podman signing secret, and persistent volumes over a custom network without modifying `app.py`.

## Specification
As user `student`:
1. Build `localhost/acme-full:1.0` from `/home/student/workspace/04-17/build/` running as numeric `USER 1001`.
2. Create user-defined network `readme-net`, named volumes `acme-notes-vol` and `acme-db-vol`, and Podman secret `acme_sign_key` with value `SignKey_0417`.
3. Start `acme-redis` (`docker.io/library/redis:7-alpine`) and `acme-pg` (`quay.io/sclorg/postgresql-16-c10s:latest` with `POSTGRESQL_USER=acme`, `POSTGRESQL_PASSWORD=acmepass`, `POSTGRESQL_DATABASE=acmedb`, mounting `acme-db-vol` at `/var/lib/pgsql/data`) on `readme-net`.
4. Start `acme-app` (`localhost/acme-full:1.0`) on `readme-net` publishing host port `8417` (`${HOST_PORT}` if `--seed` is active) to container port `8080`:
   - Mount `acme-notes-vol` at `/var/lib/webapp/data`.
   - Mount secret `acme_sign_key` at the file path expected by `webapp-flask`.
   - Set `APP_ENV=production`, `REQUIRE_STRICT_ENV=1`, `REQUIRE_SECRET=1`, `CHECK_STORAGE=1`, and configure the Redis and PostgreSQL connection variables documented in `README.md`.
5. Verify `http://127.0.0.1:8417/healthz` returns `200 OK`.
