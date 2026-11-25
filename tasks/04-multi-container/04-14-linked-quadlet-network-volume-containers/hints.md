## Level 1 — Nudge
Reference `Network=tier-net.network` (with the `.network` extension!) and `Volume=tier-pg.volume:/var/lib/pgsql/data` (with `.volume`!) so Quadlet wires unit dependencies automatically!

## Level 2 — Approach
Create all four Quadlet files in `~/.config/containers/systemd/`, verify with `/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun`, run `systemctl --user daemon-reload`, and start `q-web.service`.

## Level 3 — Key Commands
```bash
mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/tier-net.network <<'EOF'
[Network]
NetworkName=tier-net
EOF

cat > ~/.config/containers/systemd/tier-pg.volume <<'EOF'
[Volume]
VolumeName=tier-pg
EOF

cat > ~/.config/containers/systemd/q-db.container <<'EOF'
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

cat > ~/.config/containers/systemd/q-web.container <<'EOF'
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
