## Level 1 — Nudge
Use map-form `depends_on:` (`cache:` -> `condition: service_healthy`) paired with `healthcheck:` on `cache`.

## Level 2 — Approach
Write `~/workspace/04-09/compose.yaml`, bring it up via `podman compose up -d`, and verify `podman ps` shows `(healthy)` on `hc-cache`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/04-09/compose.yaml <<'EOF'
services:
  cache:
    image: docker.io/library/redis:7-alpine
    container_name: hc-cache
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 3
  web:
    image: localhost/webapp-0409:1.0
    container_name: hc-web
    ports:
      - "8409:8080"
    environment:
      APP_ENV: production
      REDIS_HOST: cache
    depends_on:
      cache:
        condition: service_healthy
EOF
cd ~/workspace/04-09 && podman compose up -d
```
