## Level 1 — Nudge
Run `podman pod inspect`, `podman network inspect`, `podman volume inspect`, `podman secret inspect`, and `podman container inspect` first without `--format` to see exact field names (`.InfraContainerID`, `.Subnets`, `.Mountpoint`, `.ID`, `.Config.User`)!

## Level 2 — Approach
Extract each field using `--format '{{...}}'` Go templates (note `(index .Subnets 0).Subnet` on `podman network inspect`) and write all 5 `KEY=VALUE` lines into `resource-inventory.env`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/05-21/resource-inventory.env <<EOF
POD_INFRA_ID=$(podman pod inspect --format '{{.InfraContainerID}}' audit-pod-0521)
NET_SUBNET=$(podman network inspect --format '{{(index .Subnets 0).Subnet}}' audit-net-0521)
VOL_MOUNTPOINT=$(podman volume inspect --format '{{.Mountpoint}}' audit-vol-0521)
SECRET_ID=$(podman secret inspect --format '{{.ID}}' audit-sec-0521)
APP_USER=$(podman container inspect --format '{{.Config.User}}' audit-worker-0521)
EOF
```
