# Task 03-03: Exposing a Rootless Web Service Publicly with firewalld Integration

## Scenario
For an external grading client to reach a rootless Podman service on RHEL 10, the container must bind `0.0.0.0:<host_port>` **and** `firewalld` must permanently allow `<host_port>/tcp`!

## Requirements
1. Launch detached container `edge-portal` from `quay.io/nginx/nginx-unprivileged:1.26-alpine` publishing container port `8080` on host port `8883` (`${EXT_PORT}` if `--seed` is active) across all interfaces (`0.0.0.0`), mounting `/home/student/apps/static-portal/public` read-only (`:ro,z`) onto `/usr/share/nginx/html`.
2. Open TCP port `8883/tcp` (`${EXT_PORT}/tcp`) both actively and permanently in `firewalld`.
3. Verify `curl http://<primary-host-ip>:8883/` returns `Cloud-Native Operations Portal`.
