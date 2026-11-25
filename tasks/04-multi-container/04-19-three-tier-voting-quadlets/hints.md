## Level 1 — Nudge
Notice the same Podman secret `qv_db_pass` can be injected as `type=env` into `qv-db.container` AND as `type=mount` into `qv-api.container` via Quadlet `Secret=`!

## Level 2 — Approach
Build `localhost/qv-ui:1.0` and `localhost/qv-api:1.0`, create `qv_db_pass`, write the 7 Quadlet files under `~/.config/containers/systemd/` (putting `[Install] WantedBy=default.target` on `qv-ui.container`, or on all 4 `.container` units), run `systemctl --user daemon-reload`, and start `qv-ui.service`.

## Level 3 — Key Commands
```bash
cd ~/workspace/04-19
podman build -t localhost/qv-ui:1.0 ./frontend
podman build -t localhost/qv-api:1.0 ./backend
printf 'QuadletVote_0419' | podman secret create qv_db_pass -

mkdir -p ~/.config/containers/systemd
printf '[Network]\nNetworkName=qv-net\n' > ~/.config/containers/systemd/qv-net.network
printf '[Volume]\nVolumeName=qv-pg\n' > ~/.config/containers/systemd/qv-pg.volume
printf '[Volume]\nVolumeName=qv-ballots\n' > ~/.config/containers/systemd/qv-ballots.volume

cat > ~/.config/containers/systemd/qv-db.container <<'EOF'
[Container]
Image=quay.io/sclorg/postgresql-16-c10s:latest
ContainerName=qv-db
Network=qv-net.network
Volume=qv-pg.volume:/var/lib/pgsql/data
Environment=POSTGRESQL_USER=voteuser
Environment=POSTGRESQL_DATABASE=votesdb
Secret=qv_db_pass,type=env,target=POSTGRESQL_PASSWORD
[Service]
Restart=always
[Install]
WantedBy=default.target
EOF

cat > ~/.config/containers/systemd/qv-cache.container <<'EOF'
[Container]
Image=docker.io/library/redis:7-alpine
ContainerName=qv-cache
Network=qv-net.network
[Service]
Restart=always
[Install]
WantedBy=default.target
EOF

cat > ~/.config/containers/systemd/qv-api.container <<'EOF'
[Unit]
Requires=qv-db.service qv-cache.service
After=qv-db.service qv-cache.service
[Container]
Image=localhost/qv-api:1.0
ContainerName=qv-api
Network=qv-net.network
Volume=qv-ballots.volume:/var/lib/voting/ballots
Environment=DB_HOST=qv-db
Environment=CACHE_HOST=qv-cache
Secret=qv_db_pass,type=mount,target=/run/secrets/db_password,uid=1001,mode=0400
[Service]
Restart=always
[Install]
WantedBy=default.target
EOF

cat > ~/.config/containers/systemd/qv-ui.container <<'EOF'
[Unit]
Requires=qv-api.service
After=qv-api.service
[Container]
Image=localhost/qv-ui:1.0
ContainerName=qv-ui
Network=qv-net.network
PublishPort=8419:8080
Environment=API_BASE_URL=http://qv-api:4000
[Service]
Restart=always
[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user start qv-ui.service
loginctl enable-linger student
```
