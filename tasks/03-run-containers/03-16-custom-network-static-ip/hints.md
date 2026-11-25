## Level 1 — Nudge
Check `man podman-network-create` (`--subnet`, `--gateway`) and `man podman-run` (`--network`, `--ip`).

## Level 2 — Approach
Run `podman network create --subnet 10.88.40.0/24 --gateway 10.88.40.1 corp-net` followed by `podman run -d --name static-node --network corp-net --ip 10.88.40.55 ...`.

## Level 3 — Key Commands
```bash
podman network create --subnet 10.88.40.0/24 --gateway 10.88.40.1 corp-net
podman run -d --name static-node --network corp-net --ip 10.88.40.55 \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600
```
