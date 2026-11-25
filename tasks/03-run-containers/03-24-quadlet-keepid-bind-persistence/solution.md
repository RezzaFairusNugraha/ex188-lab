## Solution
```bash
mkdir -p /home/student/.config/containers/systemd
cat > /home/student/.config/containers/systemd/journal-web.container <<'EOF'
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

## Explanation
`UserNS=keep-id:uid=1001,gid=1001` is the cleanest Quadlet key to memorize whenever an image runs as a non-matching fixed UID (`1001`, `101`, `26`, `999`) and needs read-write access to a host bind mount owned by `student`!

## Common Mistakes
- Writing `Userns=` instead of exact case-sensitive `UserNS=` (systemd unit keys are **case-sensitive**!).
