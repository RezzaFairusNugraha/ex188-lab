## Solution
```bash
mkdir -p /home/student/.config/containers/systemd
cat > /home/student/.config/containers/systemd/portal-quad.container <<'EOF'
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

/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun
systemctl --user daemon-reload
systemctl --user start portal-quad.service
loginctl enable-linger student
```

## Explanation
Memorize this workflow for the exam!
1. Write `~/.config/containers/systemd/<name>.container` with `WantedBy=default.target` under `[Install]`.
2. Dry-run `/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun` to catch typos immediately!
3. Run `systemctl --user daemon-reload` and `systemctl --user start <name>.service` (do **not** run `systemctl --user enable` — Quadlet's generator already creates the `default.target.wants` symlink from `[Install]`).
4. Confirm `loginctl enable-linger student`.

## Common Mistakes
- Panicking when `systemctl --user enable portal-quad.service` prints `Failed to enable unit: Unit ... is transient or generated` — `[Install] WantedBy=default.target` + `daemon-reload` IS how Quadlets enable on boot!
