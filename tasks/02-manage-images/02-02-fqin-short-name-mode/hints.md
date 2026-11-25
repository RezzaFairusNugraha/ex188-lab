## Level 1 — Nudge
Check `man containers-registries.conf` for top-level v2 syntax (`unqualified-search-registries` and `short-name-mode`).

## Level 2 — Approach
Write both keys at the top of `~/.config/containers/registries.conf`, pull `registry.access.redhat.com/ubi10/ubi-minimal:latest`, and run `podman tag ... localhost/fqin-verified:1.0`.

## Level 3 — Key Commands
```bash
mkdir -p ~/.config/containers
cat > ~/.config/containers/registries.conf <<'EOF'
unqualified-search-registries = ["registry.access.redhat.com", "quay.io"]
short-name-mode = "enforcing"
EOF
podman pull registry.access.redhat.com/ubi10/ubi-minimal:latest
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest localhost/fqin-verified:1.0
```
