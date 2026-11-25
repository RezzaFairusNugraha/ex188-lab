## Solution
```bash
mkdir -p ~/.config/containers
cat > ~/.config/containers/registries.conf <<'EOF'
unqualified-search-registries = ["registry.access.redhat.com", "quay.io"]
short-name-mode = "enforcing"
EOF

podman pull registry.access.redhat.com/ubi10/ubi-minimal:latest
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest localhost/fqin-verified:1.0
```

## Explanation
With `short-name-mode = "enforcing"`, interactive pulls prompt the user to pick a registry and record a short-name alias, while non-interactive scripts/systemd units fail immediately unless given a safe FQIN (`<registry>/<namespace>/<repo>:<tag>`).

## Common Mistakes
- Writing INI `[registries.search]` v1 syntax instead of TOML v2 syntax (`unqualified-search-registries = [...]`) — Podman v5 rejects mixed v1/v2 syntax!
