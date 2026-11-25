## Level 1 — Nudge
Run `podman search --tls-verify=false --list-tags registry.lab.local:5000/inventory/catalog-svc` to see the exact tag!

## Level 2 — Approach
The tag in `:5000` is `2.1.0` (not `v2.1`). Update `~/workspace/05-12/deploy.sh` to `registry.lab.local:5000/inventory/catalog-svc:2.1.0` and run `~/workspace/05-12/deploy.sh`.

## Level 3 — Key Commands
```bash
podman search --tls-verify=false --list-tags registry.lab.local:5000/inventory/catalog-svc
sed -i 's|inventory/catalog-svc:v2.1|registry.lab.local:5000/inventory/catalog-svc:2.1.0|' ~/workspace/05-12/deploy.sh
~/workspace/05-12/deploy.sh
```
