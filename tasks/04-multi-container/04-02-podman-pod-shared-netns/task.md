# Task 04-02: Building a Multi-Container Pod Sharing Localhost via podman pod create

## Scenario
Inside a **Podman Pod**, all member containers share the infra container's network namespace (`127.0.0.1`), so ports are published **once at Pod creation time** (`podman pod create -p ...`), never on individual member `podman run` commands!

## Requirements
1. Create a Podman pod named `portal-pod` publishing host port `8402` (`${POD_PORT}` if `--seed` is active) -> container port `8080`.
2. Start Redis container `pod-redis` (`docker.io/library/redis:7-alpine`) inside `portal-pod` (`--pod portal-pod`).
3. Start `webapp-flask` container `pod-web` (`localhost/webapp-0402:1.0`, pre-built by setup) inside `portal-pod` with `-e APP_ENV=production -e REDIS_HOST=127.0.0.1`.
4. Verify `http://127.0.0.1:8402/healthz` returns `200 OK`.
