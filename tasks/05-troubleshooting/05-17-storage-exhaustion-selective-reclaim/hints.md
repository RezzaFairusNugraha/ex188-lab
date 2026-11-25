## Level 1 — Nudge
Run `podman system df -v` to see per-image, per-container, and per-volume disk usage before pruning!

## Level 2 — Approach
Run `podman container prune -f`, `podman volume prune -f`, and `podman rmi localhost/bloated-junk:old` (avoid `podman image prune -a` so other cached UBI base images stay cached!).

## Level 3 — Key Commands
```bash
podman system df -v
podman container prune -f
podman volume prune -f
podman rmi localhost/bloated-junk:old
```
