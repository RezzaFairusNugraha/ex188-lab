## Solution
```bash
podman run -d --name retry-bounded --restart=on-failure:3 \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600

podman run -d --name retry-always --restart=always \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600

systemctl --user enable podman-restart.service
```

## Explanation
CRITICAL EXAM TRAP: Because Podman has **no background daemon**, `--restart=always` alone will **NOT** start a container after a host reboot unless either `podman-restart.service` is enabled (+ linger) OR the container is managed properly as a **Quadlet `.container` unit** (Red Hat's preferred production method on RHEL 10).

## Common Mistakes
- Assuming `podman run -d --restart=always` automatically starts after reboot like a daemon-based engine!
