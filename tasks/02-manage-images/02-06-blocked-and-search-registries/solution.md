## Solution
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt

mkdir -p /home/student/.config/containers
cat > /home/student/.config/containers/registries.conf <<'EOF'
unqualified-search-registries = ["secure-reg.lab.local:5443", "registry.access.redhat.com"]
short-name-mode = "permissive"

[[registry]]
prefix = "untrusted-public.example.io"
location = "untrusted-public.example.io"
blocked = true
EOF

podman pull approved/mini-tool:1.0
podman tag secure-reg.lab.local:5443/approved/mini-tool:1.0 localhost/mini-tool:verified
```

## Explanation
Remember that once `~/.config/containers/registries.conf` exists, it **replaces** (does not merge with!) `/etc/containers/registries.conf` for that rootless user.

## Common Mistakes
- Leaving `short-name-mode` at RHEL's default `"enforcing"`, which fails non-interactive `podman pull approved/mini-tool:1.0` when stdin is not a TTY.
