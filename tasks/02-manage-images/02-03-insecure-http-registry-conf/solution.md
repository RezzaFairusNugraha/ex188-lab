## Solution
```bash
sudo tee /etc/containers/registries.conf.d/50-lab-http.conf >/dev/null <<'EOF'
[[registry]]
location = "registry.lab.local:5000"
insecure = true
EOF

podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest registry.lab.local:5000/dev/base-ubi:1.0
podman push --remove-signatures registry.lab.local:5000/dev/base-ubi:1.0
podman rmi registry.lab.local:5000/dev/base-ubi:1.0
podman pull registry.lab.local:5000/dev/base-ubi:1.0
```

## Explanation
Notice double brackets `[[registry]]` (TOML array of tables), **not** single `[registry]`. Also note that if `~/.config/containers/registries.conf` exists in user home, Podman ignores `/etc/containers/registries.conf` for that rootless user!

## Common Mistakes
- Writing `[registry]` with single brackets instead of `[[registry]]` (causes TOML parse error).
