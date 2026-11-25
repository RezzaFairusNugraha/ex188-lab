## Solution
```bash
cat > /home/student/workspace/05-21/resource-inventory.env <<EOF
POD_INFRA_ID=$(podman pod inspect --format '{{.InfraContainerID}}' audit-pod-0521)
NET_SUBNET=$(podman network inspect --format '{{(index .Subnets 0).Subnet}}' audit-net-0521)
VOL_MOUNTPOINT=$(podman volume inspect --format '{{.Mountpoint}}' audit-vol-0521)
SECRET_ID=$(podman secret inspect --format '{{.ID}}' audit-sec-0521)
APP_USER=$(podman container inspect --format '{{.Config.User}}' audit-worker-0521)
EOF
```

## Explanation
Notice subtle Go-template struct field casing across Podman subcommands:
- `podman secret inspect` uses uppercase **`.ID`**, whereas `podman container inspect` and `podman image inspect` use **`.Id`**! Always inspect raw output once (`podman secret inspect <name>`) before writing `--format` templates!

## Common Mistakes
- Writing `{{.Id}}` on `podman secret inspect` (fails because `secret inspect` uses uppercase `{{.ID}}`).
