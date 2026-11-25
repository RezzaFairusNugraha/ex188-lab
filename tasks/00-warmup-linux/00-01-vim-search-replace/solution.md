## Solution
```bash
vim /home/student/workspace/00-01/service-draft.yaml
```
Execute the following ex-mode commands inside `vim` (or via `sed -i`):
```bash
sed -i \
  -e 's#docker.io/legacycorp#registry.access.redhat.com/ubi10#g' \
  -e 's/containerPort: 80$/containerPort: 8080/g' \
  -e '/DEPRECATED_SETTING/d' \
  -e '/^spec:$/a\\  restartPolicy: Always' \
  /home/student/workspace/00-01/service-draft.yaml
```

## Explanation
Fast ex-mode edits (`:%s`, `:g/.../d`) and two-space YAML indentation (`:set et ts=2 sw=2`) avoid manual typos when authoring `Containerfile`, Compose, and Kubernetes YAML files on a headless terminal.

## Common Mistakes
- Inserting a Tab character before `restartPolicy: Always` instead of two spaces, which breaks YAML parsers (`podman kube play`).
- Forgetting the `g` flag on substitution when multiple matches could appear on one line.
