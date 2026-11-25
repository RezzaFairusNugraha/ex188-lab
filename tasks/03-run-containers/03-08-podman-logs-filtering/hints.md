## Level 1 — Nudge
`podman logs` preserves the separation of container stdout (FD 1) and stderr (FD 2)! Use `>&` / `2>&1` when you want both, and `/dev/null` + `2>` when you want stderr only.

## Level 2 — Approach
1. Run `podman logs -t --tail 5 log-emitter > ~/workspace/03-08/recent-timestamped.log 2>&1`.
2. Run `podman logs log-emitter >/dev/null 2> ~/workspace/03-08/stderr-only.log`.

## Level 3 — Key Commands
```bash
podman logs -t --tail 5 log-emitter > ~/workspace/03-08/recent-timestamped.log 2>&1
podman logs log-emitter >/dev/null 2> ~/workspace/03-08/stderr-only.log
```
