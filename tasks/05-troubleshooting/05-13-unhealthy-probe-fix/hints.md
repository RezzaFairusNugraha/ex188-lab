## Level 1 — Nudge
Inspect `podman inspect --format '{{json .State.Health}}' portal-unhealthy` and `{{json .Config.Healthcheck}}` — check what port the probe connects to!

## Level 2 — Approach
The healthcheck probes `127.0.0.1:80`, whereas `nginx-unprivileged` listens on `8080`! Recreate `portal-unhealthy` changing `:80/` to `:8080/` in `--health-cmd` and run `podman healthcheck run portal-unhealthy`.

## Level 3 — Key Commands
```bash
podman inspect --format '{{json .Config.Healthcheck}}' portal-unhealthy
podman rm -f portal-unhealthy
podman run -d --name portal-unhealthy -p 8513:8080 \
  --health-cmd="wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1" \
  --health-interval=10s --health-retries=2 \
  quay.io/nginx/nginx-unprivileged:1.26-alpine
sleep 1 && podman healthcheck run portal-unhealthy
```
