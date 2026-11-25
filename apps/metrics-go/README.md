# Telemetry Exporter Microservice (`metrics-go`)

> **IMPORTANT — VENDOR APPLICATION NOTICE**
> Do **not** modify `main.go` or `go.mod`. Build and run this service using a multi-stage `Containerfile` as specified below.

## 1. Overview
`metrics-go` is a zero-dependency Go 1.22 HTTP service designed to compile into a static Linux binary (`CGO_ENABLED=0`) in Stage 1 and execute inside a minimal non-root runtime image (`ubi10/ubi-minimal`) in Stage 2.

## 2. Build Specification
- **Builder Stage**: Image providing Go 1.21+ (`golang:1.22` or `ubi10/ubi` with `go-toolset`).
- **Build Command**:
  ```bash
  CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/metrics-agent .
  ```
- **Runtime Stage**: `registry.access.redhat.com/ubi10/ubi-minimal:latest`
- **Target Binary Path**: `/usr/local/bin/metrics-agent` (mode `0755`)
- **Runtime User**: Numeric non-root UID `1001`

## 3. Environment Variables & Secrets

| Setting | Required | Default | Description |
| :--- | :---: | :--- | :--- |
| `METRICS_PORT` | No | `9090` | TCP port to bind on `0.0.0.0`. |
| `SERVICE_NAME` | No | `metrics-go` | Metric label `service="<value>"` emitted on `/metrics`. |
| `SCRAPE_TOKEN_FILE` | No | `/run/secrets/scrape_token` | If file exists and is non-empty, `/metrics` requires `?token=<val>` or `Authorization: Bearer <val>`. |

## 4. Endpoints
- `GET /healthz` — Always returns `200 OK` (`{"status":"ok","service":"<SERVICE_NAME>"}`).
- `GET /metrics` — Returns Prometheus-style plain-text metrics (`ex188_up{service="..."} 1`).
