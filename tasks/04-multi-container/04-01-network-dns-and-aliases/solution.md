## Solution
```bash
podman network create app-mesh

podman run -d --name cache-primary --network app-mesh \
  --network-alias redis-svc \
  --network-alias session-store \
  docker.io/library/redis:7-alpine

podman run -d --name web-client --network app-mesh \
  -p 8401:8080 \
  -e APP_ENV=production \
  -e REDIS_HOST=session-store \
  localhost/webapp-0401:1.0
```

## Explanation
`--network-alias` decouples the logical service DNS name (`session-store`) from the physical container name (`cache-primary`), allowing blue/green container swaps without reconfiguring clients.

## Common Mistakes
- Publishing `-p 6379:6379` on `cache-primary` unnecessarily — containers on `app-mesh` communicate over the internal bridge without publishing DB/cache ports to the host!
