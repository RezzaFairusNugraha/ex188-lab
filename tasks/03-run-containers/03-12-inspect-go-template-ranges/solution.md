## Solution
```bash
podman inspect --format '{{range .Mounts}}{{.Type}}:{{.Destination}}{{"\n"}}{{end}}' complex-meta \
  | sed '/^$/d' | sort > /home/student/workspace/03-12/mounts.txt

podman inspect --format '{{index .Config.Labels "com.acme.cost-center"}}' complex-meta \
  > /home/student/workspace/03-12/cost-center.txt

podman inspect --format '{{range .Config.Env}}{{println .}}{{end}}' complex-meta \
  | grep '^FEATURE_' > /home/student/workspace/03-12/features.env
```

> *Optional bonus alternative*: On workstations where `jq` is installed, `podman inspect complex-meta | jq -r '.[0].Mounts[] | "\(.Type):\(.Destination)"'` produces the same result, though Go templates are always available everywhere Podman is installed.

## Explanation
`{{range .Slice}}...{{end}}` iterates slices cleanly, while `{{index .Map "dotted.key-name"}}` safely looks up OCI labels containing dots and hyphens.

## Common Mistakes
- Writing `{{.Config.Labels.com.acme.cost-center}}`, which fails because Go templates treat `.com` as a nested struct lookup and `-center` as subtraction!
