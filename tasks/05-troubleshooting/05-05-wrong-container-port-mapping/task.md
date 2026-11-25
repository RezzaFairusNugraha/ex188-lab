# Task 05-05: Container Running Healthy Internally, Unreachable on Published Host Port

## Scenario
Container `metrics-broken-port` is `Up` and running cleanly, yet `curl http://127.0.0.1:9505/healthz` fails with `Connection reset by peer` / `Empty reply from server`! Inspect the container's logs, environment, and port mapping to fix it.

## Requirements
1. Keep published **host** port `9505` unchanged (`http://127.0.0.1:9505/healthz`).
2. Fix `metrics-broken-port` so host port `9505` forwards to the actual TCP port `metrics-agent` listens on inside the container, and verify `http://127.0.0.1:9505/healthz` returns `200 OK`.
