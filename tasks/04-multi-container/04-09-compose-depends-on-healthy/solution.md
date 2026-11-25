## Solution
```bash
cat > /home/student/workspace/04-09/compose.yaml <<'EOF'
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

cd /home/student/workspace/04-09 && podman compose up -d
```

## Explanation
`condition: service_healthy` prevents startup race conditions where an application exits on boot because PostgreSQL or Redis is still initializing its data directory.

## Common Mistakes
- Using `condition: service_healthy` when the upstream service has **no** `healthcheck:` defined!
