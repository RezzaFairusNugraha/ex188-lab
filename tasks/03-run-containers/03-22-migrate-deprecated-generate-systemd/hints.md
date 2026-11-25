## Level 1 — Nudge
Inspect the old unit file first so you don't miss `Exec=redis-server --appendonly yes`, `127.0.0.1:16379:6379`, `legacy-redis-data:/data`, or `PodmanArgs=--memory=128m`!

## Level 2 — Approach
1. `systemctl --user disable --now container-legacy-cache.service` and `rm ~/.config/systemd/user/container-legacy-cache.service`.
2. Author `~/.config/containers/systemd/legacy-cache.container` with `Exec=redis-server --appendonly yes`, `Volume=legacy-redis-data:/data`, `PublishPort=127.0.0.1:16379:6379`, and `PodmanArgs=--memory=128m`.
3. Run `systemctl --user daemon-reload && systemctl --user start legacy-cache.service`.

## Level 3 — Key Commands
```bash
systemctl --user disable --now container-legacy-cache.service
rm -f ~/.config/systemd/user/container-legacy-cache.service
podman rm -f legacy-cache 2>/dev/null || true

mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/legacy-cache.container <<'EOF'
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
