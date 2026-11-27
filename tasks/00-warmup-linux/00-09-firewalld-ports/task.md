# Task 00-09: Persistent Host Port Rules with firewall-cmd

## Objective
Publishing a container port with `podman run -p` does not automatically open `firewalld` for external clients on RHEL 10 when rootless pasta/slirp4netns binds host sockets, and stale ports must be closed.

## Specification
1. Ensure `firewalld` is active and enabled across reboots.
2. Permanently open TCP port `8448/tcp` (or `${APP_TCP_PORT}/tcp` if `--seed` is active) and UDP port `5514/udp` in the default firewalld zone.
3. Permanently remove the stale port `9999/tcp` from the default firewalld zone.
4. Reload `firewalld` so active runtime rules match the permanent configuration.
