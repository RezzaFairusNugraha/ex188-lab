## Solution
```bash
mkdir -p /home/student/.config/containers/systemd

cat > /home/student/.config/containers/systemd/telemetry-stack.pod <<'EOF'
[Pod]
PodName=telemetry-stack
PublishPort=8415:8080

[Install]
WantedBy=default.target
EOF

cat > /home/student/.config/containers/systemd/telemetry-redis.container <<'EOF'
[Container]
Image=docker.io/library/redis:7-alpine
ContainerName=telemetry-redis
Pod=telemetry-stack.pod

[Service]
Restart=always
EOF

cat > /home/student/.config/containers/systemd/telemetry-web.container <<'EOF'
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

## Explanation
When member `.container` files specify `Pod=telemetry-stack.pod`, `podman-system-generator` automatically adds `Wants=telemetry-redis.service telemetry-web.service` onto `telemetry-stack-pod.service` — so starting or enabling `telemetry-stack-pod.service` manages the entire pod lifecycle as one unit!

## Common Mistakes
- Trying `systemctl --user start telemetry-stack.service` instead of `telemetry-stack-pod.service` (`.pod` units always append `-pod.service`!).
