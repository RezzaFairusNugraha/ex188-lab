## Level 1 — Nudge
Use `--restart=on-failure:3` and `--restart=always`, then enable the built-in user helper unit `podman-restart.service`.

## Level 2 — Approach
Run both `podman run -d` commands with their respective `--restart` policies, then execute `systemctl --user enable podman-restart.service`.

## Level 3 — Key Commands
```bash
podman run -d --name retry-bounded --restart=on-failure:3 \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600
podman run -d --name retry-always --restart=always \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600
systemctl --user enable podman-restart.service
```
