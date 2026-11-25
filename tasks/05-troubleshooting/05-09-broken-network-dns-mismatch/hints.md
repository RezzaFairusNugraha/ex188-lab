## Level 1 — Nudge
Inspect `.NetworkSettings.Networks` and `.Config.Env` on both `broken-db-0509` and `broken-app-0509`!

## Level 2 — Approach
`broken-db-0509` is already on `appnet-0509`, whereas `broken-app-0509` is on default `pasta` (no `Networks` map) and has `DB_HOST=postgres-typo`. Recreate `broken-app-0509` on `--network appnet-0509` with `-e DB_HOST=broken-db-0509` (or connect an alias `--alias postgres-typo`!).

## Level 3 — Key Commands
```bash
podman rm -f broken-app-0509
podman run -d --name broken-app-0509 --network appnet-0509 -p 8509:8080 \
  -e APP_ENV=production -e DB_HOST=broken-db-0509 \
  localhost/ts-web-0509:1.0
```
