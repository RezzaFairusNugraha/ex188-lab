## Level 1 — Nudge
Check `man containers-registries.conf` for `blocked = true` inside a `[[registry]]` block and `short-name-mode = "permissive"`. Don't forget CA trust for `:5443`!

## Level 2 — Approach
1. Copy `/opt/ex188-lab/certs/ca.crt` into `/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt`.
2. Write `~/.config/containers/registries.conf` setting `unqualified-search-registries`, `short-name-mode = "permissive"`, and a `[[registry]]` block with `prefix = "untrusted-public.example.io"`, `location = "untrusted-public.example.io"`, `blocked = true`.
3. Run `podman pull approved/mini-tool:1.0` and `podman tag ... localhost/mini-tool:verified`.

## Level 3 — Key Commands
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
mkdir -p ~/.config/containers
cat > ~/.config/containers/registries.conf <<'EOF'
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
