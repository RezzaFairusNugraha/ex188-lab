## Level 1 — Nudge
Use `-d --name ... --hostname ... --user 1005:1005` for the persistent container and `podman run --rm` for the one-shot kernel query.

## Level 2 — Approach
Start `beacon-svc` detached running `sleep 3600`, then run `podman run --rm registry.access.redhat.com/ubi10/ubi-minimal:latest uname -r > ~/workspace/03-01/kernel.txt`.

## Level 3 — Key Commands
```bash
podman run -d --name beacon-svc \
  --hostname beacon.lab.internal \
  --user 1005:1005 \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600

podman run --rm registry.access.redhat.com/ubi10/ubi-minimal:latest uname -r \
  > ~/workspace/03-01/kernel.txt
```
