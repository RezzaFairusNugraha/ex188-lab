## Level 1 — Nudge
When referencing a Quadlet `.volume` inside `[Container]`, set `Volume=notes-store.volume:/var/lib/webapp/data` (with the `.volume` suffix so Quadlet wires `Requires=notes-store-volume.service` automatically!).

## Level 2 — Approach
1. Write `~/.config/containers/systemd/notes-store.volume` with `[Volume]` and `VolumeName=notes-store`.
2. Write `~/workspace/03-18/webapp.env`.
3. Write `notes-quad.container`, run `systemctl --user daemon-reload && systemctl --user start notes-quad.service`, and `curl -X POST 'http://127.0.0.1:8318/entries?msg=quadlet-vol-ok'`.

## Level 3 — Key Commands
```bash
mkdir -p ~/.config/containers/systemd ~/workspace/03-18
cat > ~/.config/containers/systemd/notes-store.volume <<'EOF'
[Volume]
VolumeName=notes-store
EOF

printf 'APP_ENV=production\nAPP_PORT=8080\n' > ~/workspace/03-18/webapp.env

cat > ~/.config/containers/systemd/notes-quad.container <<'EOF'
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
