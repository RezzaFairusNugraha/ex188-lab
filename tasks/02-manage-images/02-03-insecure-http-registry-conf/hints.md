## Level 1 — Nudge
Check `man containers-registries.conf` for `[[registry]]` array-of-tables syntax in `/etc/containers/registries.conf.d/*.conf`.

## Level 2 — Approach
Create `/etc/containers/registries.conf.d/50-lab-http.conf` with `[[registry]]`, `location = "registry.lab.local:5000"`, and `insecure = true`. Then `podman tag` and `podman push --remove-signatures registry.lab.local:5000/dev/base-ubi:1.0`.

## Level 3 — Key Commands
```bash
sudo tee /etc/containers/registries.conf.d/50-lab-http.conf >/dev/null <<'EOF'
[[registry]]
location = "registry.lab.local:5000"
insecure = true
EOF
podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest registry.lab.local:5000/dev/base-ubi:1.0
podman push --remove-signatures registry.lab.local:5000/dev/base-ubi:1.0
```
