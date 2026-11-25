## Solution
```bash
systemctl --user disable --now container-legacy-cache.service
rm -f /home/student/.config/systemd/user/container-legacy-cache.service
podman rm -f legacy-cache 2>/dev/null || true

mkdir -p /home/student/.config/containers/systemd
cat > /home/student/.config/containers/systemd/legacy-cache.container <<'EOF'
[Unit]
Description=Migrated Redis Quadlet

[Container]
Image=docker.io/library/redis:7-alpine
ContainerName=legacy-cache
PublishPort=127.0.0.1:16379:6379
Volume=legacy-redis-data:/data
PodmanArgs=--memory=128m
Exec=redis-server --appendonly yes

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user start legacy-cache.service
```

## Explanation
Any `podman run` flag that lacks a dedicated Quadlet keyword (or where you prefer direct flags like `--memory=128m`) can be supplied cleanly via `PodmanArgs=` in `[Container]`!

## Common Mistakes
- Omitting `Exec=redis-server --appendonly yes`, causing Redis to ignore `appendonly.aof` and start with an empty dataset (`MIGRATION_CHECK` = `nil`)!
