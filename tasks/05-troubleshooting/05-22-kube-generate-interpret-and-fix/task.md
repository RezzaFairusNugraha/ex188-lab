# Task 05-22: Interpreting YAML from podman kube generate and Remediating Mismatched Resource Specs

## Objective
Running pod `misconfigured-pod` (`localhost/ts-web-0522:1.0` + `redis:7-alpine`) has **four** specification defects compared to the architecture requirements:
1. Published `hostPort` is `18599` instead of required **`8522`**.
2. `APP_ENV` is set to `development` instead of **`production`**.
3. `REDIS_HOST` is set to `wrong-redis-host` instead of **`127.0.0.1`** (inside the shared Pod!).
4. Container `web` lacks a memory limit — requirements mandate `resources.limits.memory: 192Mi`.

## Specification
1. Export `misconfigured-pod` to `/home/student/workspace/05-22/remediated-pod.yaml` using `podman kube generate`.
2. Read and edit `/home/student/workspace/05-22/remediated-pod.yaml` to fix all four mismatches (`hostPort: 8522`, `APP_ENV: production`, `REDIS_HOST: 127.0.0.1`, `resources.limits.memory: 192Mi`).
3. Remove the old `misconfigured-pod` and redeploy from `/home/student/workspace/05-22/remediated-pod.yaml` via `podman kube play` (`--replace`) so `http://127.0.0.1:8522/healthz` returns `200 OK`!
