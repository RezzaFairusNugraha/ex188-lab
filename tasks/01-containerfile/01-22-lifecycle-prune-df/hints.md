## Level 1 — Nudge
Use `podman container prune` and `podman image prune` (without `-a`, so tagged unused images are safe), then redirect `podman system df`.

## Level 2 — Approach
Run `podman container prune -f`, `podman image prune -f`, verify `keep-alive-svc` is still running with `podman ps -a`, and run `podman system df > ~/workspace/01-22/system-df.txt`.

## Level 3 — Key Commands
```bash
podman container prune -f
podman image prune -f
podman system df > ~/workspace/01-22/system-df.txt
```
