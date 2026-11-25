## Solution
```bash
podman logs metrics-broken-port
podman rm -f metrics-broken-port
podman run -d --name metrics-broken-port \
  -p 9505:9095 \
  -e METRICS_PORT=9095 \
  -e SERVICE_NAME=ts-0505 \
  localhost/ts-metrics-0505:1.0
```

## Explanation
`Connection reset by peer` on a published container port is the classic symptom that host port forwarding succeeded, but **nothing inside the container** is listening on that target container port (`80` vs `9095`)!

## Common Mistakes
- Forgetting to preserve `-e SERVICE_NAME=ts-0505` when recreating the container! Always inspect `.Config.Env` before `podman rm`.
