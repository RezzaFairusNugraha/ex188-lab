## Level 1 — Nudge
Create `customers-pgvol`, populate `accounts` in `customers-db-v1`, remove `customers-db-v1` **without** `-v` (`podman rm -v` deletes anonymous volumes, keep `customers-pgvol`), and start `customers-db-v2`.

## Level 2 — Approach
Wait ~5 seconds after starting `customers-db-v1` before running `podman exec customers-db-v1 psql -U crm -d crmdb -c "..."`. Then `podman rm -f customers-db-v1` and launch `customers-db-v2` with `-v customers-pgvol:/var/lib/pgsql/data`.

## Level 3 — Key Commands
```bash
podman volume create customers-pgvol
podman run -d --name customers-db-v1 \
  -e POSTGRESQL_USER=crm -e POSTGRESQL_PASSWORD=crmpass -e POSTGRESQL_DATABASE=crmdb \
  -v customers-pgvol:/var/lib/pgsql/data \
  quay.io/sclorg/postgresql-16-c10s:latest
sleep 5
podman exec customers-db-v1 psql -U crm -d crmdb \
  -c "CREATE TABLE accounts(id INT, name TEXT); INSERT INTO accounts VALUES (1, 'RedHat-Enterprise');"
podman rm -f customers-db-v1
podman run -d --name customers-db-v2 \
  -e POSTGRESQL_USER=crm -e POSTGRESQL_PASSWORD=crmpass -e POSTGRESQL_DATABASE=crmdb \
  -v customers-pgvol:/var/lib/pgsql/data \
  quay.io/sclorg/postgresql-16-c10s:latest
```
