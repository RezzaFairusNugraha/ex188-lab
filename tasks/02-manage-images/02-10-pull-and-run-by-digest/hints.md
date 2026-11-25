## Level 1 — Nudge
Pull `:v1` with `--tls-verify=false`, read `{{.Digest}}` from `podman image inspect`, then run `podman run -d --tls-verify=false --name digest-runner <repo>@<digest> sleep 3600`.

## Level 2 — Approach
1. `podman pull --tls-verify=false registry.lab.local:5000/sec/audit-runner:v1`
2. Extract `DIG=$(podman image inspect --format '{{.Digest}}' registry.lab.local:5000/sec/audit-runner:v1)`.
3. Save `registry.lab.local:5000/sec/audit-runner@${DIG}` to `pinned-ref.txt` and start `digest-runner` using that exact string.

## Level 3 — Key Commands
```bash
podman pull --tls-verify=false registry.lab.local:5000/sec/audit-runner:v1
DIG=$(podman image inspect --format '{{.Digest}}' registry.lab.local:5000/sec/audit-runner:v1)
REF="registry.lab.local:5000/sec/audit-runner@${DIG}"
echo "$REF" > ~/workspace/02-10/pinned-ref.txt
podman run -d --tls-verify=false --name digest-runner "$REF" sleep 3600
```
