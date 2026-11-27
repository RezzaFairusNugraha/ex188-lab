# Task 04-04: Injecting Podman Secrets as Environment Variables (--secret type=env) for Database Images

## Objective
Some container images (such as `quay.io/sclorg/postgresql-16-c10s:latest`) expect `POSTGRESQL_PASSWORD` as an environment variable rather than a `/run/secrets/*` file. Passing `--secret <name>,type=env,target=POSTGRESQL_PASSWORD` injects the secret at runtime **without** storing the plain-text value in `podman inspect` `Config.Env`!

## Specification
1. Create Podman secret `pg_admin_pass` with value `PgSecret_9081` (no trailing newline).
2. Create named volume `pgdata-0404`.
3. Start detached PostgreSQL container `secure-pg` (`quay.io/sclorg/postgresql-16-c10s:latest`) with:
   - `-e POSTGRESQL_USER=appuser`
   - `-e POSTGRESQL_DATABASE=ordersdb`
   - `--secret pg_admin_pass,type=env,target=POSTGRESQL_PASSWORD`
   - `-v pgdata-0404:/var/lib/pgsql/data`
4. Verify PostgreSQL accepts connections for `appuser` against `ordersdb` and `PgSecret_9081` does NOT appear in `podman inspect secure-pg`!
