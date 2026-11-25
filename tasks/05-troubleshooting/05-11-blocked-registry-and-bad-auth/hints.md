## Level 1 — Nudge
Check `~/.config/containers/registries.conf` first (`blocked = true`), then re-authenticate explicitly targeting `--authfile ~/.config/containers/auth.json`!

## Level 2 — Approach
Remove `blocked = true` (or remove `~/.config/containers/registries.conf`), run `podman login --authfile ~/.config/containers/auth.json -u student -p redhat123 auth-reg.lab.local:5444`, and launch `sec-scanner`.

## Level 3 — Key Commands
```bash
rm -f ~/.config/containers/registries.conf
podman login --authfile ~/.config/containers/auth.json -u student -p redhat123 auth-reg.lab.local:5444
podman run -d --name sec-scanner --authfile ~/.config/containers/auth.json \
  auth-reg.lab.local:5444/sec/scanner:2.0 sleep 3600
```
