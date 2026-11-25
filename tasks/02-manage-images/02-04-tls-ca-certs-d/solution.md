## Solution
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest secure-reg.lab.local:5443/qa/verified-ubi:1.0
podman push --remove-signatures secure-reg.lab.local:5443/qa/verified-ubi:1.0
```

## Explanation
Unlike system-wide `/etc/pki/ca-trust/source/anchors/` (`update-ca-trust`), `/etc/containers/certs.d/<host:port>/ca.crt` scopes trust solely to that container registry endpoint without requiring a daemon restart.

## Common Mistakes
- Naming the directory `/etc/containers/certs.d/secure-reg.lab.local` **without** `:5443` — when a registry runs on a non-443 port, the directory name **must** include `:port`!
- Copying `ca.crt` with `0600` root-only permissions so rootless `student` cannot read it.
