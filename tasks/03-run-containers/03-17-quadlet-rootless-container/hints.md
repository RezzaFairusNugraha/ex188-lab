## Level 1 — Nudge
Read `man podman-systemd.unit`! Rootless Quadlets go in `~/.config/containers/systemd/<name>.container` and require `[Container]`, `[Service]`, and `[Install]` (`WantedBy=default.target`).

## Level 2 — Approach
Create `~/.config/containers/systemd/portal-quad.container`, test with `/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun`, run `systemctl --user daemon-reload`, run `systemctl --user start portal-quad.service`, and verify `loginctl enable-linger student`.

## Level 3 — Key Commands
```bash
mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/portal-quad.container <<'EOF'
[Unit]
Description=EX188 Portal Quadlet Service

[Container]
Image=quay.io/nginx/nginx-unprivileged:1.26-alpine
ContainerName=portal-quad
PublishPort=8317:8080

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user start portal-quad.service
loginctl enable-linger student
```
