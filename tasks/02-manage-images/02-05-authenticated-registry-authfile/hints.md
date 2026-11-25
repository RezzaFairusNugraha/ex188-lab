## Level 1 — Nudge
By default, `podman login` writes to `/run/user/$UID/containers/auth.json` (`tmpfs`, lost on reboot!). Pass `--authfile ~/.config/containers/auth.json` to persist credentials across reboots!

## Level 2 — Approach
1. Install `/opt/ex188-lab/certs/ca.crt` to `/etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt`.
2. Run `podman login --authfile ~/.config/containers/auth.json -u ci-bot -p 'Ex188Pass!' auth-reg.lab.local:5444`.
3. Tag and push `auth-reg.lab.local:5444/prod/core-ubi:1.0` with `--authfile ~/.config/containers/auth.json`.

## Level 3 — Key Commands
```bash
sudo mkdir -p /etc/containers/certs.d/auth-reg.lab.local:5444
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt
mkdir -p ~/.config/containers
podman login --authfile ~/.config/containers/auth.json -u ci-bot -p 'Ex188Pass!' auth-reg.lab.local:5444
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest auth-reg.lab.local:5444/prod/core-ubi:1.0
podman push --remove-signatures --authfile ~/.config/containers/auth.json auth-reg.lab.local:5444/prod/core-ubi:1.0
```
