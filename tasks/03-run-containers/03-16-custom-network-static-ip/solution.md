## Solution
```bash
podman network create --subnet 10.88.40.0/24 --gateway 10.88.40.1 corp-net
podman run -d --name static-node \
  --network corp-net \
  --ip 10.88.40.55 \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600
```

## Explanation
Unlike the default rootless `pasta` network mode (which shares host user-mode stack without an isolated bridge), user-defined networks created via `podman network create` instantiate a Netavark bridge + `aardvark-dns` inside a rootless network namespace.

## Common Mistakes
- Passing `--ip` without `--network <custom-bridge>` (static container IPs require a bridge network with an explicit subnet).
