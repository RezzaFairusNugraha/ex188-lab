# Task 04-18: Full 3-Tier stack-voting Deployment via compose.yaml

## Objective
Read `/home/student/apps/stack-voting/README.md`. Deploy the complete 4-container PulseVote suite (`vote-ui`, `vote-api`, `vote-db`, `vote-cache`) using `/home/student/workspace/04-18/compose.yaml`.

## Specification
1. Build `localhost/vote-ui:1.0` and `localhost/vote-api:1.0` from `/home/student/apps/stack-voting/{frontend,backend}` (staged in `/home/student/workspace/04-18/`).
2. Create Podman secret `voting_db_secret` (`VoteDbPass_0418`).
3. Author `/home/student/workspace/04-18/compose.yaml` launching:
   - `vote-db` (`quay.io/sclorg/postgresql-16-c10s:latest`, named volume `vote-pgdata:/var/lib/pgsql/data`, `POSTGRESQL_USER=voteuser`, `POSTGRESQL_DATABASE=votesdb`, `POSTGRESQL_PASSWORD=VoteDbPass_0418`).
   - `vote-cache` (`docker.io/library/redis:7-alpine`).
   - `vote-api` (`localhost/vote-api:1.0`, `DB_HOST=vote-db`, `CACHE_HOST=vote-cache`, named volume `vote-ballots:/var/lib/voting/ballots`, external secret `voting_db_secret` mounted at `/run/secrets/db_password`).
   - `vote-ui` (`localhost/vote-ui:1.0`, publishing `8418:8080`, `API_BASE_URL=http://vote-api:4000`, mounting custom `/home/student/workspace/04-18/voting.conf` read-only at `/etc/voting/voting.conf` with `POLL_TITLE=EX188 Compose Poll`).
4. Bring the stack up, cast a ballot via `POST http://127.0.0.1:8418/vote`, and verify `GET http://127.0.0.1:8418/healthz` returns `200 OK`!
