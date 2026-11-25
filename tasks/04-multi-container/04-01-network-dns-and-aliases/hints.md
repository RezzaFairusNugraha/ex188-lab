## Level 1 — Nudge
Create `app-mesh` with `podman network create`, pass `--network app-mesh --network-alias ...` to `cache-primary`, and pass `--network app-mesh -e REDIS_HOST=session-store` to `web-client`.

## Level 2 — Approach
1. `podman network create app-mesh`
2. Run `cache-primary` with `--network app-mesh --network-alias redis-svc --network-alias session-store`.
3. Run `web-client` with `--network app-mesh -p 8401:8080 -e APP_ENV=production -e REDIS_HOST=session-store`.

## Level 3 — Key Commands
```bash
podman network create app-mesh
podman run -d --name cache-primary --network app-mesh \
  --network-alias redis-svc --network-alias session-store \
  docker.io/library/redis:7-alpine
podman run -d --name web-client --network app-mesh -p 8401:8080 \
  -e APP_ENV=production -e REDIS_HOST=session-store \
  localhost/webapp-0401:1.0
```
