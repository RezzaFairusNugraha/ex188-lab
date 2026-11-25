## Level 1 — Nudge
Publish `-p 8402:8080` on `podman pod create`, then attach both containers with `--pod portal-pod` (with NO `-p` on `podman run`)!

## Level 2 — Approach
Run `podman pod create --name portal-pod -p 8402:8080`, start `pod-redis` with `--pod portal-pod`, and start `pod-web` with `--pod portal-pod -e APP_ENV=production -e REDIS_HOST=127.0.0.1`.

## Level 3 — Key Commands
```bash
podman pod create --name portal-pod -p 8402:8080
podman run -d --name pod-redis --pod portal-pod docker.io/library/redis:7-alpine
podman run -d --name pod-web --pod portal-pod \
  -e APP_ENV=production -e REDIS_HOST=127.0.0.1 \
  localhost/webapp-0402:1.0
```
