## Level 1 — Nudge
Export `misconfigured-pod` via `podman kube generate -f ~/workspace/05-22/remediated-pod.yaml misconfigured-pod`, edit `hostPort`, `env`, and `resources: limits: memory: 192Mi` in `vim`, then run `podman kube play --replace`.

## Level 2 — Approach
1. Generate `remediated-pod.yaml` with `podman kube generate`.
2. Update `hostPort: 8522`, `APP_ENV` -> `production`, `REDIS_HOST` -> `127.0.0.1`, and replace `resources: {}` on container `web` with `resources: { limits: { memory: 192Mi } }`.
3. Run `podman pod rm -f misconfigured-pod && podman kube play ~/workspace/05-22/remediated-pod.yaml`.

## Level 3 — Key Commands
```bash
podman kube generate -f ~/workspace/05-22/remediated-pod.yaml misconfigured-pod
# Edit ~/workspace/05-22/remediated-pod.yaml:
#   hostPort: 8522
#   APP_ENV -> value: production
#   REDIS_HOST -> value: 127.0.0.1
#   resources:
#     limits:
#       memory: 192Mi
podman pod rm -f misconfigured-pod
podman kube play ~/workspace/05-22/remediated-pod.yaml
```
