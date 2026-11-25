## Level 1 — Nudge
Run `podman image inspect --format '{{.Config.Volumes}} | {{.Config.Env}}' quay.io/sclorg/postgresql-16-c10s:latest` — check the exact `HOME`/`VOLUME` path!

## Level 2 — Approach
Red Hat's `postgresql-16-c10s` stores data in `/var/lib/pgsql/data` (not `/var/lib/postgresql/data`!). Remove `orders-db`, recreate it mounting `-v orders-pgvol:/var/lib/pgsql/data`, wait 5s, and create `shipments` with `'SHP-9901'`.

## Level 3 — Key Commands
```bash
podman rm -f orders-db
podman run -d --name orders-db \
  -e POSTGRESQL_USER=ord -e POSTGRESQL_PASSWORD=ordpass -e POSTGRESQL_DATABASE=orddb \
  -v orders-pgvol:/var/lib/pgsql/data \
  quay.io/sclorg/postgresql-16-c10s:latest
sleep 5
podman exec orders-db psql -U ord -d orddb \
  -c "CREATE TABLE shipments(code TEXT); INSERT INTO shipments VALUES ('SHP-9901');"
```
