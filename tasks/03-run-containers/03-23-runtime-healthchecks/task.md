# Task 03-23: Configuring Runtime Healthchecks (--health-cmd) and On-Failure Action

## Scenario
Even when an upstream image has **no** `HEALTHCHECK` baked into its `Containerfile` (or was built in OCI format), `podman run` can attach full health probes and automated recovery actions (`--health-on-failure`) at runtime!

## Requirements
1. Start detached container `probed-nginx` on `-p 8323:8080` from `quay.io/nginx/nginx-unprivileged:1.26-alpine` with runtime healthcheck flags:
   - `--health-cmd="wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1"`
   - `--health-interval=10s`
   - `--health-retries=3`
   - `--health-timeout=3s`
   - `--health-on-failure=restart`
2. Trigger an immediate probe via `podman healthcheck run probed-nginx` so its status transitions from `starting` to `healthy`.
