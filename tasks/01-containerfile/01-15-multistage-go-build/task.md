# Task 01-15: Multi-Stage Go Application Build into a Minimal Runtime Image

## Objective
Source files for `metrics-go` (`go.mod`, `main.go`, and `README.md`) have been pre-staged in `/home/student/workspace/01-15/`. Build a minimal production image using a multi-stage `Containerfile` so no Go toolchain or source files exist in the final image.

## Specification
As user `student`:
1. Create a two-stage `/home/student/workspace/01-15/Containerfile`:
   - **Stage 1**: Compile a static Linux binary (`CGO_ENABLED=0`) using `docker.io/library/golang:1.22`.
   - **Stage 2**: Use `registry.access.redhat.com/ubi10/ubi-minimal:latest`, copy **only** the compiled binary to `/usr/local/bin/metrics-agent` (mode `0755`), expose `9090/tcp`, run as numeric `USER 1001`, and configure exec-form `ENTRYPOINT ["/usr/local/bin/metrics-agent"]`.
2. Build the image as `localhost/metrics-go:1.0`.
3. Start detached container `metrics-agent` publishing host port `9190` (`${HOST_PORT}` if `--seed` is active) to container port `9090` with environment variable `SERVICE_NAME=edge-telemetry`.
