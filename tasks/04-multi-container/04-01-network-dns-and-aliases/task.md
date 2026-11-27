# Task 04-01: Container-to-Container DNS Resolution and Network Aliases on User-Defined Networks

## Objective
Containers on the default network cannot resolve each other by name, whereas containers attached to a user-defined Podman network automatically resolve both container names and `--network-alias` DNS records via `aardvark-dns`.

## Specification
1. Create a user-defined Podman network named `app-mesh`.
2. Start detached Redis container `cache-primary` (`docker.io/library/redis:7-alpine`) on `app-mesh` with `--network-alias redis-svc` and `--network-alias session-store`.
3. Start detached `webapp-flask` container `web-client` (`localhost/webapp-0401:1.0`, pre-built by setup) on `app-mesh` publishing `-p 8401:8080` with `-e APP_ENV=production -e REDIS_HOST=session-store`.
4. Verify `http://127.0.0.1:8401/healthz` returns `200 OK` (`"reachable": true`).
