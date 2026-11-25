## Solution
```bash
podman inspect --format '{{json .State.Health}}' portal-unhealthy
podman rm -f portal-unhealthy

podman run -d --name portal-unhealthy -p 8513:8080 \
  --health-cmd="wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1" \
  --health-interval=10s \
  --health-retries=2 \
  quay.io/nginx/nginx-unprivileged:1.26-alpine

sleep 1
podman healthcheck run portal-unhealthy
```

## Explanation
Remember: `HEALTHCHECK` runs **inside** the container's network namespace, so it must probe the **container port** (`8080`), never `80` (privileged) and never the host port (`8513`)!

## Common Mistakes
- Changing the healthcheck to probe `8513` (the host port) instead of `8080` (the container port)!
