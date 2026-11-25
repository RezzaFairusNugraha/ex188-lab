## Solution
```bash
podman image inspect --format '{{json .Config.Volumes}}' quay.io/sclorg/postgresql-16-c10s:latest
podman rm -f orders-db

podman run -d --name orders-db \
  -e POSTGRESQL_USER=ord \
  -e POSTGRESQL_PASSWORD=ordpass \
  -e POSTGRESQL_DATABASE=orddb \
  -v orders-pgvol:/var/lib/pgsql/data \
  quay.io/sclorg/postgresql-16-c10s:latest

sleep 5
podman exec orders-db psql -U ord -d orddb \
  -c "CREATE TABLE shipments(code TEXT); INSERT INTO shipments VALUES ('SHP-9901');"
```

## Explanation
`podman diff orders-db` before the fix immediately reveals `A /var/lib/pgsql/data/userdata/...` landing in the ephemeral container upper layer! Always inspect `{{.Config.Volumes}}` on unfamiliar DB images (`mariadb`, `postgresql`, `mongodb`) before assuming Docker Hub paths!

## Common Mistakes
- Guessing `/var/lib/postgresql/data` instead of inspecting `Config.Volumes` on Red Hat SCLorg/UBI database images (`/var/lib/pgsql/data`, `/var/lib/mysql/data`).
