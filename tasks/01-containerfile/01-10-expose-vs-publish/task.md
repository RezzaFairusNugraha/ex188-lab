# Task 01-10: EXPOSE Metadata vs Runtime Port Publishing (-p and -P)

## Scenario
Many candidates mistakenly assume `EXPOSE` inside a `Containerfile` publishes a host port on its own. In reality, `EXPOSE` records image metadata that `podman run -P` (`--publish-all`) uses to map random ephemeral host ports, while `-p` maps explicit ports.

## Requirements
1. Create `/home/student/workspace/01-10/Containerfile` from `quay.io/nginx/nginx-unprivileged:1.26-alpine`, copying `/home/student/apps/static-portal/conf/nginx.conf` to `/etc/nginx/conf.d/default.conf` and `/home/student/apps/static-portal/public/` to `/usr/share/nginx/html/`.
2. Declare `EXPOSE 8080` in the `Containerfile` and build `localhost/portal-expose:1.0`.
3. Start container `portal-explicit` publishing container port `8080` on explicit host port `8091` (`${HOST_PORT}` if `--seed` is active).
4. Start container `portal-auto` using `-P` (`--publish-all`) and save its dynamically assigned host TCP port number (integer only) to `/home/student/workspace/01-10/auto-port.txt`.
