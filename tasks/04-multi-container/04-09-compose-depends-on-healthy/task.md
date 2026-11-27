# Task 04-09: Gating Stack Startup on Upstream Healthchecks in compose.yaml

## Objective
Plain `depends_on: [cache]` only waits for the container to *start*, not for the service inside it to become *ready*! Defining a `healthcheck:` on `cache` and `condition: service_healthy` under `depends_on:` ensures `web` starts only after Redis responds to `PING`.

## Specification
In `/home/student/workspace/04-09/compose.yaml`:
1. Define service `cache` (`container_name: hc-cache`, `docker.io/library/redis:7-alpine`) with a `healthcheck:` running `["CMD", "redis-cli", "ping"]` (`interval: 5s`, `timeout: 3s`, `retries: 3`).
2. Define service `web` (`container_name: hc-web`, `localhost/webapp-0409:1.0`) publishing `8409:8080` with `APP_ENV=production`, `REDIS_HOST=cache`, and `depends_on:` waiting for `cache` with `condition: service_healthy`.
3. Launch the stack with `podman compose up -d` and verify `hc-cache` is `healthy` and `http://127.0.0.1:8409/healthz` returns `200`.
