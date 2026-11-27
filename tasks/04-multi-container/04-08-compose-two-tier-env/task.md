# Task 04-08: Two-Tier Web and PostgreSQL Deployment via compose.yaml and .env Interpolation

## Objective
Deploy `webapp-flask` (`localhost/webapp-0408:1.0`, pre-built) backed by PostgreSQL 16 (`quay.io/sclorg/postgresql-16-c10s:latest`) using `podman compose` (`podman-compose`) with variable interpolation from `/home/student/workspace/04-08/.env`.

## Specification
In `/home/student/workspace/04-08/`:
1. Create `.env` setting `PUBLISHED_PORT=8408`, `PG_USER=appdb`, `PG_PASS=composepass88`, and `PG_NAME=portaldb`.
2. Create `compose.yaml` defining:
   - Custom network `backend-net` and named volume `db-storage`.
   - Service `db` (`container_name: compose-db`, image `quay.io/sclorg/postgresql-16-c10s:latest`) mounting `db-storage:/var/lib/pgsql/data` and interpolating `${PG_USER}`, `${PG_PASS}`, `${PG_NAME}`.
   - Service `web` (`container_name: compose-web`, image `localhost/webapp-0408:1.0`) publishing `${PUBLISHED_PORT}:8080` with `APP_ENV=production` and `DB_HOST=db`.
3. Bring the stack up detached (`podman compose up -d` or `podman-compose up -d`) and verify `http://127.0.0.1:8408/healthz` returns `200 OK`.
