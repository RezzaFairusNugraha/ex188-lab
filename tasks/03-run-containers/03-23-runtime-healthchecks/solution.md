## Solution
```bash
podman run -d --name probed-nginx -p 8323:8080 \
  --health-cmd="wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1" \
  --health-interval=10s \
  --health-retries=3 \
  --health-timeout=3s \
  --health-on-failure=restart \
  quay.io/nginx/nginx-unprivileged:1.26-alpine

sleep 1
podman healthcheck run probed-nginx
```

## Explanation
Runtime `--health-*` flags work even on OCI-format images where `Containerfile` `HEALTHCHECK` was stripped! Note that inside minimal Alpine images (`nginx-unprivileged:1.26-alpine`), BusyBox `wget` is installed by default whereas `curl` may not be.

## Common Mistakes
- Using `curl` in `--health-cmd` on an Alpine base that only includes `wget`, causing permanent `unhealthy` exit code `127`!
