## Level 1 — Nudge
Check the `EXAMPLE` section near the bottom of `man containers-registries.conf` for `[[registry]]` + `[[registry.mirror]]`!

## Level 2 — Approach
1. Install `/opt/ex188-lab/certs/ca.crt` to `/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt`.
2. Write `/etc/containers/registries.conf.d/60-corp-mirror.conf` with `[[registry]]`, `prefix = "upstream-hub.corp.example"`, `location = "upstream-hub.corp.example"`, followed by `[[registry.mirror]]` and `location = "secure-reg.lab.local:5443"`.
3. Test `podman pull upstream-hub.corp.example/platform/agent:2.1`.

## Level 3 — Key Commands
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
sudo tee /etc/containers/registries.conf.d/60-corp-mirror.conf >/dev/null <<'EOF'
[[registry]]
prefix = "upstream-hub.corp.example"
location = "upstream-hub.corp.example"

[[registry.mirror]]
location = "secure-reg.lab.local:5443"
EOF
podman pull upstream-hub.corp.example/platform/agent:2.1
```
