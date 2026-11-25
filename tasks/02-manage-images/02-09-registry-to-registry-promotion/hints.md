## Level 1 — Nudge
Trust the `:5443` CA first, then execute the classic `podman pull` -> `podman tag` -> `podman push` -> `podman rmi <old-tag>` workflow.

## Level 2 — Approach
1. Copy `/opt/ex188-lab/certs/ca.crt` to `/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt`.
2. Pull from `:5000` with `--tls-verify=false`.
3. Tag to `secure-reg.lab.local:5443/release/order-worker:1.4`, push to `:5443`, and remove the local `:rc4` tag.

## Level 3 — Key Commands
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
podman pull --tls-verify=false registry.lab.local:5000/staging/order-worker:rc4
podman tag registry.lab.local:5000/staging/order-worker:rc4 secure-reg.lab.local:5443/release/order-worker:1.4
podman push secure-reg.lab.local:5443/release/order-worker:1.4
podman rmi registry.lab.local:5000/staging/order-worker:rc4
```
