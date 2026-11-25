## Solution
```bash
sed -i 's/blocked = true/blocked = false/' /home/student/.config/containers/registries.conf
podman login \
  --authfile /home/student/.config/containers/auth.json \
  -u student -p redhat123 \
  auth-reg.lab.local:5444

podman run -d --name sec-scanner \
  --authfile /home/student/.config/containers/auth.json \
  auth-reg.lab.local:5444/sec/scanner:2.0 sleep 3600
```

## Explanation
Notice why running plain `podman login` without `--authfile` can confuse troubleshooting: Podman checks `$XDG_RUNTIME_DIR/containers/auth.json` first and `~/.config/containers/auth.json` second — updating `~/.config/containers/auth.json` directly fixes both interactive and post-reboot systemd pulls!

## Common Mistakes
- Updating `/run/user/1000/containers/auth.json` while leaving broken base64 credentials inside `~/.config/containers/auth.json`.
