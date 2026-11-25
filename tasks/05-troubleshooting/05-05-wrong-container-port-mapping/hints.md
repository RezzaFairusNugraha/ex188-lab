## Level 1 — Nudge
Compare `podman logs metrics-broken-port` (which prints the actual port the binary bound inside the container!) against `podman port metrics-broken-port`!

## Level 2 — Approach
`podman logs metrics-broken-port` shows `listening on 0.0.0.0:9095` (`METRICS_PORT=9095`), whereas `-p` mapped `9505->80/tcp`! Recreate `metrics-broken-port` preserving `-e METRICS_PORT=9095 -e SERVICE_NAME=ts-0505` with `-p 9505:9095`.

## Level 3 — Key Commands
```bash
podman logs metrics-broken-port
podman inspect --format '{{.Config.Env}}' metrics-broken-port
podman rm -f metrics-broken-port
podman run -d --name metrics-broken-port -p 9505:9095 \
  -e METRICS_PORT=9095 -e SERVICE_NAME=ts-0505 \
  localhost/ts-metrics-0505:1.0
```
