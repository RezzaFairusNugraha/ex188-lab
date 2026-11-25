## Solution
```bash
mkdir -p /home/student/.config/containers/systemd

cat > /home/student/.config/containers/systemd/tier-net.network <<'EOF'
[Network]
NetworkName=tier-net
EOF

cat > /home/student/.config/containers/systemd/tier-pg.volume <<'EOF'
[Volume]
VolumeName=tier-pg
EOF

cat > /home/student/.config/containers/systemd/q-db.container <<'EOF'
[Container]
Image=quay.io/sclorg/postgresql-16-c10s:latest
ContainerName=q-db
Network=tier-net.network
Volume=tier-pg.volume:/var/lib/pgsql/data
Environment=POSTGRESQL_USER=quser
Environment=POSTGRESQL_PASSWORD=qpass
Environment=POSTGRESQL_DATABASE=qdb

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

cat > /home/student/.config/containers/systemd/q-web.container <<'EOF'
[Unit]
Requires=q-db.service
After=q-db.service

[Container]
Image=localhost/webapp-0414:1.0
ContainerName=q-web
Network=tier-net.network
PublishPort=8414:8080
Environment=APP_ENV=production
Environment=DB_HOST=q-db

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user start q-web.service
```

## Explanation
Because `q-web.container` has `Requires=q-db.service` and `After=q-db.service` under `[Unit]`, starting `q-web.service` automatically creates `tier-net`, creates `tier-pg`, starts `q-db.service` first, and then starts `q-web.service`!

## Common Mistakes
- Writing `Requires=q-db.container` instead of the generated systemd unit name `Requires=q-db.service`!
