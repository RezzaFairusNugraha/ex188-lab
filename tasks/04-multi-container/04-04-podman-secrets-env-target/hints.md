## Level 1 — Nudge
Use `printf 'PgSecret_9081' | podman secret create pg_admin_pass -` (note `printf` without `\n`!) and `--secret pg_admin_pass,type=env,target=POSTGRESQL_PASSWORD`.

## Level 2 — Approach
Create the secret and volume `pgdata-0404`, launch `secure-pg` with `-e POSTGRESQL_USER=appuser -e POSTGRESQL_DATABASE=ordersdb --secret pg_admin_pass,type=env,target=POSTGRESQL_PASSWORD -v pgdata-0404:/var/lib/pgsql/data`, and wait ~4 seconds for DB initialization.

## Level 3 — Key Commands
```bash
printf 'PgSecret_9081' | podman secret create pg_admin_pass -
podman volume create pgdata-0404
podman run -d --name secure-pg \
  -e POSTGRESQL_USER=appuser \
  -e POSTGRESQL_DATABASE=ordersdb \
  --secret pg_admin_pass,type=env,target=POSTGRESQL_PASSWORD \
  -v pgdata-0404:/var/lib/pgsql/data \
  quay.io/sclorg/postgresql-16-c10s:latest
```
