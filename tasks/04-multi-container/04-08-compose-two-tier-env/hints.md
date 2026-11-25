## Level 1 — Nudge
Place `.env` in the same directory as `compose.yaml` so `podman compose` interpolates `${VAR}` expressions automatically!

## Level 2 — Approach
Write `.env` and `compose.yaml` inside `~/workspace/04-08/`, `cd ~/workspace/04-08`, and run `podman compose up -d`.

## Level 3 — Key Commands
```bash
cd ~/workspace/04-08
cat > .env <<'EOF'
PUBLISHED_PORT=8408
PG_USER=appdb
PG_PASS=composepass88
PG_NAME=portaldb
EOF

cat > compose.yaml <<'EOF'
services:
  db:
    image: quay.io/sclorg/postgresql-16-c10s:latest
    container_name: compose-db
    environment:
      POSTGRESQL_USER: ${PG_USER}
      POSTGRESQL_PASSWORD: ${PG_PASS}
      POSTGRESQL_DATABASE: ${PG_NAME}
    volumes:
      - db-storage:/var/lib/pgsql/data
    networks:
      - backend-net
  web:
    image: localhost/webapp-0408:1.0
    container_name: compose-web
    depends_on:
      - db
    ports:
      - "${PUBLISHED_PORT}:8080"
    environment:
      APP_ENV: production
      DB_HOST: db
    networks:
      - backend-net
volumes:
  db-storage:
networks:
  backend-net:
EOF
podman compose up -d
```
