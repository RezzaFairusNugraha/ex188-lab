## Solution
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

## Explanation
CRITICAL DETAIL: `echo 'PgSecret_9081' | podman secret create ...` appends a trailing `\n` (`PgSecret_9081\n`), which becomes part of `POSTGRESQL_PASSWORD` when `type=env` is used! Always use `printf '%s' 'PgSecret_9081'` or `echo -n` when creating secrets!

## Common Mistakes
- Using `echo` (with newline) instead of `printf '%s'` when piping a password into `podman secret create`!
