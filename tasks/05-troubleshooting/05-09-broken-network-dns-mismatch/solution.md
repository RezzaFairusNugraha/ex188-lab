## Solution
```bash
podman rm -f broken-app-0509
podman run -d --name broken-app-0509 \
  --network appnet-0509 \
  -p 8509:8080 \
  -e APP_ENV=production \
  -e DB_HOST=broken-db-0509 \
  localhost/ts-web-0509:1.0
```

## Explanation
Inspecting `podman network ls` and `podman inspect --format '{{.NetworkSettings.Networks}}' <ctr>` immediately reveals when one container was accidentally started without `--network <custom-net>`.

## Common Mistakes
- Recreating `broken-db-0509` without `-v pgvol-0509:/var/lib/pgsql/data` (`broken-db-0509` was already configured properly — only `broken-app-0509` needed recreation!).
