## Level 1 — Nudge
Check `man podman-run` (search `/--health-`) and `man podman-healthcheck-run`.

## Level 2 — Approach
Start `probed-nginx` with all five `--health-*` flags, wait 1 second for Nginx to bind `:8080`, and execute `podman healthcheck run probed-nginx`.

## Level 3 — Key Commands
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
