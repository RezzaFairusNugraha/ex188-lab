## Solution
```bash
sudo mkdir -p /etc/containers/certs.d/auth-reg.lab.local:5444
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt
mkdir -p /home/student/.config/containers

podman login \
  --authfile /home/student/.config/containers/auth.json \
  -u ci-bot -p 'Ex188Pass!' \
  auth-reg.lab.local:5444

podman tag registry.access.redhat.com/ubi10/ubi-minimal:latest auth-reg.lab.local:5444/prod/core-ubi:1.0
podman push --authfile /home/student/.config/containers/auth.json auth-reg.lab.local:5444/prod/core-ubi:1.0
```

## Explanation
Remember this critical EX188 persistence detail: `podman login` defaults to `$XDG_RUNTIME_DIR/containers/auth.json` (`/run/user/1000/containers/auth.json`), which resides on `tmpfs` and disappears on reboot! Writing to `~/.config/containers/auth.json` ensures Quadlet units with `AutoUpdate=registry` or unpulled images still authenticate after reboot!

## Common Mistakes
- Running `podman login` without `--authfile ~/.config/containers/auth.json`, losing registry credentials after reboot.
- Allowing `!` in `"Ex188Pass!"` to trigger Bash history expansion inside double quotes (always wrap passwords containing `!` in single quotes `'Ex188Pass!'`).
