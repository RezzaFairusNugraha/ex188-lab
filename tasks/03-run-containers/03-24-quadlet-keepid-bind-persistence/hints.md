## Level 1 — Nudge
Check `man podman-systemd.unit` for `UserNS=` inside `[Container]` (`UserNS=keep-id:uid=1001,gid=1001`).

## Level 2 — Approach
Write `~/.config/containers/systemd/journal-web.container` with `UserNS=keep-id:uid=1001,gid=1001` and `Volume=/srv/student-journal:/var/lib/webapp/data:Z`, reload and start `journal-web.service`, post `survived-restart-test`, and restart the service to confirm persistence.

## Level 3 — Key Commands
```bash
mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/journal-web.container <<'EOF'
[Container]
Image=localhost/webapp-0324:1.0
ContainerName=journal-web
PublishPort=8324:8080
Environment=APP_ENV=production
Environment=CHECK_STORAGE=1
UserNS=keep-id:uid=1001,gid=1001
Volume=/srv/student-journal:/var/lib/webapp/data:Z

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user start journal-web.service
sleep 2
curl -fsS -X POST 'http://127.0.0.1:8324/entries?msg=survived-restart-test'
systemctl --user restart journal-web.service
loginctl enable-linger student
```
