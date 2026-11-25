## Level 1 — Nudge
Use `{{range .Mounts}}{{println .Type ":" .Destination}}{{end}}` (or `printf`), `{{index .Config.Labels "com.acme.cost-center"}}`, and `{{range .Config.Env}}{{println .}}{{end}}`.

## Level 2 — Approach
1. Run `podman inspect --format '{{range .Mounts}}{{.Type}}:{{.Destination}}{{"\n"}}{{end}}' complex-meta | sort > ~/workspace/03-12/mounts.txt`.
2. Run `podman inspect --format '{{index .Config.Labels "com.acme.cost-center"}}' complex-meta > ~/workspace/03-12/cost-center.txt`.
3. Run `podman inspect --format '{{range .Config.Env}}{{println .}}{{end}}' complex-meta | grep '^FEATURE_' > ~/workspace/03-12/features.env`.

## Level 3 — Key Commands
```bash
podman inspect --format '{{range .Mounts}}{{.Type}}:{{.Destination}}{{"\n"}}{{end}}' complex-meta \
  | sed '/^$/d' | sort > ~/workspace/03-12/mounts.txt
podman inspect --format '{{index .Config.Labels "com.acme.cost-center"}}' complex-meta \
  > ~/workspace/03-12/cost-center.txt
podman inspect --format '{{range .Config.Env}}{{println .}}{{end}}' complex-meta \
  | grep '^FEATURE_' > ~/workspace/03-12/features.env
```
