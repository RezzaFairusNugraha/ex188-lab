# Task 05-09: Fixing Inter-Container Connectivity: Default Network Isolation and Wrong DB_HOST

## Scenario
`http://127.0.0.1:8509/healthz` on `broken-app-0509` returns `503 Service Unavailable`. Inspect `broken-app-0509` and `broken-db-0509` to find **two** networking bugs preventing `broken-app-0509` from reaching PostgreSQL!

## Requirements
1. Preserve container names `broken-db-0509` and `broken-app-0509`, published port `8509->8080`, and DB volume `pgvol-0509`!
2. Connect both containers onto user-defined network `appnet-0509` (`podman network connect` or container recreation) and fix `DB_HOST` on `broken-app-0509` so `http://127.0.0.1:8509/healthz` returns `200 OK` (`"reachable": true`).
