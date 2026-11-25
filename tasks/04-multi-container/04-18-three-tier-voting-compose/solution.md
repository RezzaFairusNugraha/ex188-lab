## Solution
```bash
cd /home/student/workspace/04-18
podman build -t localhost/vote-ui:1.0 ./frontend
podman build -t localhost/vote-api:1.0 ./backend
printf 'VoteDbPass_0418' | podman secret create voting_db_secret -

cat > voting.conf <<'EOF'
POLL_TITLE=EX188 Compose Poll
OPTION_A=Podman Quadlet
OPTION_B=Kubernetes YAML
EOF
chmod 0644 voting.conf

cat > compose.yaml <<'EOF'
services:
  vote-db:
    image: quay.io/sclorg/postgresql-16-c10s:latest
    container_name: vote-db
    environment:
      POSTGRESQL_USER: voteuser
      POSTGRESQL_PASSWORD: VoteDbPass_0418
      POSTGRESQL_DATABASE: votesdb
    volumes:
      - vote-pgdata:/var/lib/pgsql/data
    networks: [votenet]

  vote-cache:
    image: docker.io/library/redis:7-alpine
    container_name: vote-cache
    networks: [votenet]

  vote-api:
    image: localhost/vote-api:1.0
    container_name: vote-api
    depends_on: [vote-db, vote-cache]
    environment:
      DB_HOST: vote-db
      CACHE_HOST: vote-cache
    volumes:
      - vote-ballots:/var/lib/voting/ballots
    secrets:
      - source: voting_db_secret
        target: db_password
    networks: [votenet]

  vote-ui:
    image: localhost/vote-ui:1.0
    container_name: vote-ui
    depends_on: [vote-api]
    ports:
      - "8418:8080"
    environment:
      API_BASE_URL: http://vote-api:4000
    volumes:
      - ./voting.conf:/etc/voting/voting.conf:ro,z
    networks: [votenet]

volumes:
  vote-pgdata:
  vote-ballots:

networks:
  votenet:

secrets:
  voting_db_secret:
    external: true
EOF

podman compose up -d
sleep 5
curl -fsS -X POST http://127.0.0.1:8418/vote
```

## Explanation
Notice only `vote-ui` publishes a host port (`8418:8080`); `vote-api`, `vote-db`, and `vote-cache` remain completely isolated inside `votenet`!

## Common Mistakes
- Publishing internal database/API ports to `0.0.0.0` when only the frontend UI should be exposed externally.
