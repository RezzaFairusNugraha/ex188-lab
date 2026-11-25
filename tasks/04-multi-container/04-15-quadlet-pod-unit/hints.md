## Level 1 — Nudge
Check `man podman-systemd.unit` (`[Pod]` section)! Note that `foo.pod` generates a systemd unit named `foo-pod.service`!

## Level 2 — Approach
Write `telemetry-stack.pod` (`WantedBy=default.target`), `telemetry-redis.container` (`Pod=telemetry-stack.pod`), and `telemetry-web.container` (`Pod=telemetry-stack.pod`), run `systemctl --user daemon-reload`, and start `telemetry-stack-pod.service` (which automatically starts its member containers when linked, or start `telemetry-web.service` + `telemetry-redis.service`).

## Level 3 — Key Commands
```bash
mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/telemetry-stack.pod <<'EOF'
[Pod]
PodName=telemetry-stack
PublishPort=8415:8080

[Install]
WantedBy=default.target
EOF

cat > ~/.config/containers/systemd/telemetry-redis.container <<'EOF'
[Container]
Image=docker.io/library/redis:7-alpine
ContainerName=telemetry-redis
Pod=telemetry-stack.pod

[Service]
Restart=always
EOF

cat > ~/.config/containers/systemd/telemetry-web.container <<'EOF'
[Unit]
After=telemetry-redis.service

[Container]
Image=localhost/webapp-0415:1.0
ContainerName=telemetry-web
Pod=telemetry-stack.pod
Environment=APP_ENV=production
Environment=REDIS_HOST=127.0.0.1

[Service]
Restart=always
EOF
systemctl --user daemon-reload
systemctl --user start telemetry-stack-pod.service
loginctl enable-linger student
```
