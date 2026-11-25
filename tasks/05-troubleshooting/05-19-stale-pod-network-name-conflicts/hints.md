## Level 1 — Nudge
Check `podman pod ps -a`, `podman ps -a`, and `podman network inspect $(podman network ls -q)` to find every colliding object without touching `do-not-touch-0519`!

## Level 2 — Approach
Remove `orders-web` (`podman rm -f orders-web`), `orders-pod` (`podman pod rm -f orders-pod`), and `stale-subnet-50` (`podman network rm stale-subnet-50`), then execute `~/workspace/05-19/deploy-stack.sh`.

## Level 3 — Key Commands
```bash
podman rm -f orders-web
podman pod rm -f orders-pod
podman network rm stale-subnet-50
~/workspace/05-19/deploy-stack.sh
```
