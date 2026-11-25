## Level 1 — Nudge
Check `man podman-search` for `--format` template fields (`{{.Name}}`) and `--tls-verify=false`.

## Level 2 — Approach
Run `podman search --tls-verify=false --format "{{.Name}}" registry.lab.local:5000/ops`, pipe through `sort`, and save to `~/workspace/02-01/repos.txt`.

## Level 3 — Key Commands
```bash
podman search --tls-verify=false --format "{{.Name}}" registry.lab.local:5000/ops \
  | sort > ~/workspace/02-01/repos.txt
```
