# Task 01-15: Multi-Stage Go Build (metrics-go) into Minimal Non-Root Runtime Image

## Scenario
Read `/home/student/apps/metrics-go/README.md`. Shipping the Go compiler inside production images adds hundreds of megabytes and unnecessary tooling. Build `metrics-go` using a two-stage `Containerfile`.

## Requirements
1. Copy `/home/student/apps/metrics-go/` into `/home/student/workspace/01-15/` and author `/home/student/workspace/01-15/Containerfile`:
   - **Stage 1 (`AS builder`)**: Compile a static Linux binary `/out/metrics-agent` (`CGO_ENABLED=0`) using `docker.io/library/golang:1.22` (or `registry.access.redhat.com/ubi10/ubi:latest` with `golang` installed via `dnf`).
   - **Stage 2 (runtime)**: Start from `registry.access.redhat.com/ubi10/ubi-minimal:latest`, copy **only** `/out/metrics-agent` from `builder` to `/usr/local/bin/metrics-agent` (`--chmod=0755`), expose `9090`, run as numeric `USER 1001`, and set `ENTRYPOINT ["/usr/local/bin/metrics-agent"]`.
2. Build `localhost/metrics-go:1.0` and verify neither `go` nor `main.go` exists in the final image.
3. Run detached container `metrics-agent` publishing host port `9190` (`${HOST_PORT}` if `--seed` is active) to container port `9090` with `-e SERVICE_NAME=edge-telemetry`.
