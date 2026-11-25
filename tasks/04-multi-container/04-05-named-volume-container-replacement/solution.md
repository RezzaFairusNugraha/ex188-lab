## Solution
```bash
podman volume create customers-pgvol

podman run -d --name customers-db-v1 \
  -e POSTGRESQL_USER=crm \
  -e POSTGRESQL_PASSWORD=crmpass \
  -e POSTGRESQL_DATABASE=crmdb \
  -v customers-pgvol:/var/lib/pgsql/data \
  quay.io/sclorg/postgresql-16-c10s:latest

sleep 5
podman exec customers-db-v1 psql -U crm -d crmdb \
  -c "CREATE TABLE accounts(id INT, name TEXT); INSERT INTO accounts VALUES (1, 'RedHat-Enterprise');"

podman rm -f customers-db-v1

podman run -d --name customers-db-v2 \
  -e POSTGRESQL_USER=crm \
  -e POSTGRESQL_PASSWORD=crmpass \
  -e POSTGRESQL_DATABASE=crmdb \
  -v customers-pgvol:/var/lib/pgsql/data \
  quay.io/sclorg/postgresql-16-c10s:latest
```

## Explanation
`quay.io/sclorg/postgresql-16-c10s` runs as UID `26` (`postgres`), and its image already owns `/var/lib/pgsql/data` as `26:26` — so Podman named volumes inherit `26:26` automatically without manual `podman unshare chown`!

## Common Mistakes
- Mounting `/var/lib/postgresql/data` (Debian/Docker Hub path) instead of `/var/lib/pgsql/data` (Red Hat/SCLorg PostgreSQL path!), causing all DB files to vanish on container removal!
