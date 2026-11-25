## Solution
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
rm -f /home/student/.config/containers/registries.conf

sudo tee /etc/containers/registries.conf.d/60-corp-mirror.conf >/dev/null <<'EOF'
[[registry]]
prefix = "upstream-hub.corp.example"
location = "upstream-hub.corp.example"

[[registry.mirror]]
location = "secure-reg.lab.local:5443"
EOF

podman pull upstream-hub.corp.example/platform/agent:2.1
```

## Explanation
When pulling `upstream-hub.corp.example/platform/agent:2.1`, Podman tries each `[[registry.mirror]]` location in order (`secure-reg.lab.local:5443/platform/agent:2.1`), and tags the resulting local image under the requested name `upstream-hub.corp.example/platform/agent:2.1` so existing `Containerfile` `FROM` lines work untouched! Note that `podman push` never redirects to a mirror.

## Common Mistakes
- Writing `[registry.mirror]` with single brackets instead of `[[registry.mirror]]` (array of tables).
