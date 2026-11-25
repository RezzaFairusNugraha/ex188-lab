## Level 1 — Nudge
`podman tag SOURCE TARGET1 TARGET2 TARGET3 ...` accepts multiple target tags in a single command!

## Level 2 — Approach
Apply all five target tags to `localhost/portal-build:ci` with `podman tag`, then loop over them with `podman push --tls-verify=false`.

## Level 3 — Key Commands
```bash
podman tag localhost/portal-build:ci \
  registry.lab.local:5000/web/portal:2.3.1 \
  registry.lab.local:5000/web/portal:2.3 \
  registry.lab.local:5000/web/portal:2 \
  registry.lab.local:5000/web/portal:latest \
  registry.lab.local:5000/archive/portal:2.3.1

for img in \
  registry.lab.local:5000/web/portal:{2.3.1,2.3,2,latest} \
  registry.lab.local:5000/archive/portal:2.3.1; do
  podman push --tls-verify=false "$img"
done
```
