## Level 1 — Nudge
Check `podman ps --format '{{.Names}} {{.Ports}}'` and `ss -tulpn | grep 8504`.

## Level 2 — Approach
Spot `rogue-squatter-0504` holding `0.0.0.0:8504->8080/tcp` via `podman ps`, remove it with `podman rm -f rogue-squatter-0504`, and run `podman start prod-portal-0504`.

## Level 3 — Key Commands
```bash
podman ps
podman rm -f rogue-squatter-0504
podman start prod-portal-0504
```
