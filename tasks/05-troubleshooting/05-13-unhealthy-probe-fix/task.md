# Task 05-13: Diagnosing and Fixing an unhealthy Container via State.Health.Log

## Objective
Container `portal-unhealthy` (`quay.io/nginx/nginx-unprivileged:1.26-alpine` on `-p 8513:8080`) serves HTTP requests normally on `:8513`, yet `podman ps` marks it **`(unhealthy)`**! Inspect `.State.Health` and `.Config.Healthcheck` on `portal-unhealthy` to see why the health probe is failing!

## Specification
1. Recreate `portal-unhealthy` on `-p 8513:8080` from `quay.io/nginx/nginx-unprivileged:1.26-alpine` with a corrected `--health-cmd` (`--health-interval=10s --health-retries=2`) probing the actual port/binary available inside the container.
2. Run `podman healthcheck run portal-unhealthy` and verify its health status is **`healthy`**.
