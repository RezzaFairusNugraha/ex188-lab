## Level 1 — Nudge
Check `man podman-search` (`--list-tags`) and `man podman-manifest-inspect`. Neither command pulls layers into local storage!

## Level 2 — Approach
Run `podman search --tls-verify=false --list-tags registry.lab.local:5000/catalog/billing-api > ~/workspace/02-08/tags-output.txt` and `podman manifest inspect --tls-verify=false docker://registry.lab.local:5000/catalog/billing-api:2.0-rc1 > ~/workspace/02-08/manifest.json`.

## Level 3 — Key Commands
```bash
podman search --tls-verify=false --list-tags registry.lab.local:5000/catalog/billing-api \
  > ~/workspace/02-08/tags-output.txt
podman manifest inspect --tls-verify=false docker://registry.lab.local:5000/catalog/billing-api:2.0-rc1 \
  > ~/workspace/02-08/manifest.json
```
