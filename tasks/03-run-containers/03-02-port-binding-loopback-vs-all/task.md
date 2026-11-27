# Task 03-02: Publishing Host Ports: Loopback-Only (127.0.0.1) vs All Interfaces

## Objective
Internal admin panels should bind strictly to `127.0.0.1:<port>` so external network interfaces cannot reach them, whereas public frontends bind `0.0.0.0:<port>`.

## Specification
Using `quay.io/nginx/nginx-unprivileged:1.26-alpine` (which listens on `8080/tcp`):
1. Run detached container `admin-local` publishing container port `8080` bound **exclusively** to `127.0.0.1:18081`.
2. Run detached container `public-front` publishing container port `8080` on all host IPv4 interfaces (`0.0.0.0:18082`, or `0.0.0.0:${PUB_PORT}` if `--seed` is active).
3. Save the output of `podman port admin-local` to `/home/student/workspace/03-02/admin-port.txt`.
