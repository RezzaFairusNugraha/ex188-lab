## Level 1 — Nudge
Podman looks up per-registry CA certificates inside `/etc/containers/certs.d/<host:port>/ca.crt` (including the `:5443` port in the directory name!).

## Level 2 — Approach
Create `/etc/containers/certs.d/secure-reg.lab.local:5443`, copy `/opt/ex188-lab/certs/ca.crt` into it with world-readable `0644` permissions so rootless `student` can read it, then `podman tag` and `podman push`.

## Level 3 — Key Commands
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest secure-reg.lab.local:5443/qa/verified-ubi:1.0
podman push --remove-signatures secure-reg.lab.local:5443/qa/verified-ubi:1.0
```
