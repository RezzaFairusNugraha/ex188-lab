# Northwind Inventory REST API (`api-express`)

> **IMPORTANT — VENDOR APPLICATION NOTICE**
> Do **not** edit `server.js` or `package.json`. Deploy this service using Podman, `Containerfile`, secrets, and mounted configuration files according to the specification below.

## 1. Overview
`api-express` is a Node.js HTTP microservice serving product catalog items and writing audit records to a mounted volume.

## 2. Runtime Requirements
- **Runtime**: Node.js 20+ (`nodejs` package on `ubi10/ubi` or `node:20-slim`)
- **Dependencies**: Install via `npm install --omit=dev` (uses `express` if installed, with built-in Node HTTP fallback for air-gapped builds).
- **Working Directory**: `/opt/api-express`
- **Entrypoint / Command**: `["node", "server.js"]`
- **User**: Must run as non-root UID `1001` (or arbitrary non-root UID with group `0` write access).

## 3. Environment Variables & Secrets

| Setting | Required | Default | Description |
| :--- | :---: | :--- | :--- |
| `PORT` | Yes | `3000` | Listening TCP port inside the container. |
| `NODE_ENV` | No | `production` | Runtime profile reported by `/api/v1/info`. |
| `CATALOG_FILE` | No | `/etc/api-express/catalog.json` | Read-only JSON catalog file path. |
| `AUDIT_DIR` | No | `/var/lib/api-express/audit` | Writable directory where `POST /api/v1/audit` stores JSONL logs. |
| `API_TOKEN_FILE` | Cond. | `/run/secrets/api_token` | Path to secret file holding bearer token (required when `AUTH_REQUIRED=true`). |
| `API_TOKEN` | Cond. | *(none)* | Fallback env-var token if `API_TOKEN_FILE` is not mounted. |
| `AUTH_REQUIRED` | No | `false` | When `true`, container exits with code `1` at boot if no token is provided, and `/api/v1/audit` requires `X-API-Token`. |

## 4. Endpoints
- `GET /healthz` — Returns `200 OK` (`{"status":"healthy"}`).
- `GET /api/v1/info` — Returns runtime metadata (`service`, `node_env`, `uid`, `auth_configured`, `catalog_count`).
- `GET /api/v1/items` — Returns JSON array parsed from `CATALOG_FILE`.
- `POST /api/v1/audit` — Appends an audit event into `${AUDIT_DIR}/audit.log` (requires header `X-API-Token` when `AUTH_REQUIRED=true`).
