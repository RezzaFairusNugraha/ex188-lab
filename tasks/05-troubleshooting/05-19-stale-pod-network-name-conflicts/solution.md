## Solution
```bash
podman pod ps -a
podman ps -a
podman network ls

podman rm -f orders-web
podman pod rm -f orders-pod
podman network rm stale-subnet-50
/home/student/workspace/05-19/deploy-stack.sh
```

## Explanation
Netavark rejects overlapping IPv4 subnets (`subnet 10.89.50.0/24 is already used on the host or by another config`), and `podman ps` without `-a` hides `Created`/`Exited` containers (`orders-web`) that still reserve container names!

## Common Mistakes
- Running `podman ps` without `-a` and wondering why `name "orders-web" is in use`!
