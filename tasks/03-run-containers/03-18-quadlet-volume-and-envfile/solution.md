## Solution
```bash
mkdir -p /home/student/.config/containers/systemd /home/student/workspace/03-18

cat > /home/student/.config/containers/systemd/notes-store.volume <<'EOF'
[Volume]
VolumeName=notes-store
EOF

cat > /home/student/workspace/03-18/webapp.env <<'EOF'
APP_ENV=production
APP_PORT=8080
EOF

cat > /home/student/.config/containers/systemd/notes-quad.container <<'EOF'
[Container]
Image=localhost/webapp-0318:1.0
ContainerName=notes-quad
PublishPort=8318:8080
EnvironmentFile=/home/student/workspace/03-18/webapp.env
Volume=notes-store.volume:/var/lib/webapp/data

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user start notes-quad.service
sleep 2
curl -fsS -X POST 'http://127.0.0.1:8318/entries?msg=quadlet-vol-ok'
```

## Explanation
Notice `EnvironmentFile=` inside `[Container]` passes `--env-file` directly to `podman run` (unlike `[Service]` `EnvironmentFile=`, which exposes variables to the host systemd process rather than inside the container!).

## Common Mistakes
- Putting `EnvironmentFile=` under `[Service]` instead of `[Container]`! Variables under `[Service]` do NOT automatically enter the container!
