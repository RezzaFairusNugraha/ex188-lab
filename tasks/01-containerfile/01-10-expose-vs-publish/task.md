# Task 01-10: Image EXPOSE Metadata and Runtime Port Publishing

## Objective
Static web assets (`conf/nginx.conf`, `public/`, and `README.md`) have been pre-staged in `/home/student/workspace/01-10/`. Package the web portal image and launch two containers demonstrating explicit vs dynamic host port publishing.

## Specification
As user `student`:
1. Create `/home/student/workspace/01-10/Containerfile` from `quay.io/nginx/nginx-unprivileged:1.26-alpine`:
   - Copy `conf/nginx.conf` to `/etc/nginx/conf.d/default.conf` (world-readable so Nginx UID `101` can read it).
   - Copy the contents of `public/` into `/usr/share/nginx/html/`.
   - Declare TCP port `8080` in image metadata and build `localhost/portal-expose:1.0`.
2. Start detached container `portal-explicit` from `localhost/portal-expose:1.0` publishing host port `8091` (`${HOST_PORT}` if `--seed` is active) to container port `8080`.
3. Start detached container `portal-auto` from `localhost/portal-expose:1.0` publishing all exposed ports to ephemeral host ports automatically, and write **only** the assigned numeric host TCP port to `/home/student/workspace/01-10/auto-port.txt`.
