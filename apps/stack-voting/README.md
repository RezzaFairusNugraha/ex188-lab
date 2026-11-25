# PulseVote 3-Tier Multi-Container Suite (`stack-voting`)

> **IMPORTANT — VENDOR APPLICATION NOTICE**
> Do **not** modify source files under `frontend/`, `backend/`, or `db/`. Deploy this multi-tier stack using `podman compose`, `podman pod` / `podman kube play`, or Podman Quadlet units according to the contract below.

## 1. Architecture Overview
`stack-voting` comprises four cooperating containers on an isolated network (or shared Pod namespace):
1. **`vote-ui` (`frontend/`)** — Python HTTP frontend listening on `8080/tcp`. Proxies vote requests and status checks to `vote-api`.
2. **`vote-api` (`backend/`)** — Node.js backend API listening on `4000/tcp`. Validates a shared secret, checks connectivity to `vote-db` and `vote-cache`, and persists ballots.
3. **`vote-db` (`quay.io/sclorg/postgresql-16-c10s:latest`)** — PostgreSQL 16 database listening on `5432/tcp`, initialized from `db/init.sql` with persistent storage at `/var/lib/pgsql/data`.
4. **`vote-cache` (`docker.io/library/redis:7-alpine`)** — In-memory cache listening on `6379/tcp`.

## 2. Required Configuration Contract

### `vote-ui` (`frontend/`)
- **Port**: `UI_PORT` (default `8080`)
- **Upstream API URL**: `API_BASE_URL` (required, e.g. `http://vote-api:4000` on bridge network or `http://127.0.0.1:4000` inside a shared Pod)
- **Config File**: `VOTING_CONF` (default `/etc/voting/voting.conf`, sample at `config/voting.conf`)
- **Healthcheck**: `GET /healthz` (`200 OK` when `vote-api` is reachable)

### `vote-api` (`backend/`)
- **Port**: `API_PORT` (default `4000`)
- **Database Settings**: `DB_HOST` (e.g. `vote-db`), `DB_PORT` (`5432`), `DB_NAME` (`votesdb`), `DB_USER` (`voteuser`), and `DB_PASSWORD_FILE` (`/run/secrets/db_password`) or `DB_PASSWORD`
- **Cache Settings**: `CACHE_HOST` (e.g. `vote-cache`), `CACHE_PORT` (`6379`)
- **Persistent State Dir**: `BALLOT_DIR` (`/var/lib/voting/ballots`)
- **Healthcheck**: `GET /healthz` (`200 OK` when both `DB_HOST:DB_PORT` and `CACHE_HOST:CACHE_PORT` accept TCP connections and DB password secret is non-empty)

### `vote-db` (`quay.io/sclorg/postgresql-16-c10s:latest`)
- **Environment**: `POSTGRESQL_USER=voteuser`, `POSTGRESQL_DATABASE=votesdb`, `POSTGRESQL_PASSWORD` (or secret env)
- **Volume**: Persistent named volume mounted at `/var/lib/pgsql/data`
- **Schema Seed**: `db/init.sql` (can be mounted read-only or applied via `podman exec`)
