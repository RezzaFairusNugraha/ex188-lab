## Solution
```bash
podman search --tls-verify=false --list-tags registry.lab.local:5000/inventory/catalog-svc
sed -i 's|inventory/catalog-svc:v2.1|registry.lab.local:5000/inventory/catalog-svc:2.1.0|' /home/student/workspace/05-12/deploy.sh
/home/student/workspace/05-12/deploy.sh
```

## Explanation
`manifest unknown` means the repository was reached but the tag (`v2.1` vs `2.1.0`) does not exist; `short-name resolution enforced` means the registry hostname was omitted in non-TTY execution.

## Common Mistakes
- Fixing `:2.1.0` while forgetting to prepend `registry.lab.local:5000/`.
