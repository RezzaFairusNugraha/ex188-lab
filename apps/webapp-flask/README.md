# Acme Cloud Status & Notes Service (`webapp-flask`)

> **IMPORTANT — VENDOR APPLICATION NOTICE**
> Do **not** modify `app.py` or `requirements.txt`. Configure and deploy this application strictly through `Containerfile` instructions, environment variables, mounted configuration files, Podman secrets, and persistent volumes as documented below.

## 1. Overview
`webapp-flask` is a Python 3 / Flask HTTP service that exposes runtime health, configuration inspection, optional upstream TCP connectivity checks (PostgreSQL & Redis/Valkey), and a persistent note journal stored on disk.

## 2. Runtime Dependencies
- **Language Runtime**: Python 3.11+ (`python3` and `python3-pip` on `ubi10/ubi`, or `python:3.12-slim`)
- **Python Packages**: Listed in `requirements.txt` (`Flask>=3.0,<4.0`, `Werkzeug>=3.0,<4.0`)
- **Process Execution**: Run `python3 /opt/webapp/app.py` in **exec form** so `SIGTERM` is handled cleanly.
- **Security Requirement**: Must run as a **non-root user** (recommended numeric UID `1001` or OpenShift-compatible `1001:0`).

## 3. Environment Variables

| Variable | Required | Default | Description |
| :--- | :---: | :--- | :--- |
| `APP_PORT` | Yes (in prod) | `8080` | TCP port the HTTP server listens on inside the container. |
| `APP_BIND` | No | `0.0.0.0` | Interface address to bind (`0.0.0.0` for container publishing). |
| `APP_ENV` | Yes | *(none)* | Deployment tier (`development`, `staging`, or `production`). When `REQUIRE_STRICT_ENV=1`, startup exits with code `1` if unset. |
| `REQUIRE_STRICT_ENV` | No | `0` | Set to `1` to enforce presence of `APP_ENV` and secret material at startup. |
| `CONFIG_PATH` | No | `/etc/webapp/app.conf` | Path to optional `KEY=VALUE` configuration file. |
| `DATA_DIR` | No | `/var/lib/webapp/data` | Writable directory used by `/entries` to persist notes across container restarts. |
| `APP_SECRET` | Cond. | *(none)* | Application signing token passed via environment variable (use `--secret ...,type=env` or prefer `APP_SECRET_FILE`). |
| `APP_SECRET_FILE` | Cond. | `/run/secrets/webapp_secret` | File path containing the signing token (preferred Podman secret mount target). |
| `REDIS_HOST` | No | *(none)* | Optional cache hostname; verified on `/healthz` when set. |
| `REDIS_PORT` | No | `6379` | Optional cache TCP port. |
| `DB_HOST` | No | *(none)* | Optional PostgreSQL hostname; verified on `/healthz` when set. |
| `DB_PORT` | No | `5432` | Optional PostgreSQL TCP port. |

## 4. Configuration File Format (`CONFIG_PATH`)
Plain text `KEY=VALUE` lines (`#` comments ignored). Supported keys:
```ini
SITE_TITLE=Acme Internal Portal
SUPPORT_TEAM=platform-ops@example.com
MAINTENANCE_MODE=false
```

## 5. Volumes & Permissions
- Mount a named volume or host directory onto `/var/lib/webapp/data` (or custom `DATA_DIR`).
- On SELinux-enabled RHEL 10 hosts, host bind mounts **must** carry `:Z` (private) or `:z` (shared) labels, and the directory must be writable by the container UID.

## 6. HTTP Endpoints
- `GET /` — Returns JSON summary (`service`, `env`, `site_title`, `uid`, `secret_loaded`).
- `GET /healthz` — Returns `200 OK` (`{"status":"ok"}`), or `503` if configured `REDIS_HOST` / `DB_HOST` is unreachable or `DATA_DIR` is unwritable when `CHECK_STORAGE=1`.
- `GET /config` — Returns parsed values from `CONFIG_PATH` (never exposes secret values).
- `GET /entries` — Lists persisted journal lines from `${DATA_DIR}/entries.log`.
- `POST /entries` — Appends body text (or `?msg=...`) as a new line in `${DATA_DIR}/entries.log`.
