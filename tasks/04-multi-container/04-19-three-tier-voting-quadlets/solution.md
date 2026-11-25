## Solution
```bash
cd /home/student/workspace/04-19
podman build -t localhost/qv-ui:1.0 ./frontend
podman build -t localhost/qv-api:1.0 ./backend
printf 'QuadletVote_0419' | podman secret create qv_db_pass -

mkdir -p /home/student/.config/containers/systemd
printf '[Network]\nNetworkName=qv-net\n' > /home/student/.config/containers/systemd/qv-net.network
printf '[Volume]\nVolumeName=qv-pg\n' > /home/student/.config/containers/systemd/qv-pg.volume
printf '[Volume]\nVolumeName=qv-ballots\n' > /home/student/.config/containers/systemd/qv-ballots.volume

cat > /home/student/.config/containers/systemd/qv-db.container <<'EOF'
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

cat > /home/student/.config/containers/systemd/qv-cache.container <<'EOF'
[Container]
Image=docker.io/library/redis:7-alpine
ContainerName=qv-cache
Network=qv-net.network

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

cat > /home/student/.config/containers/systemd/qv-api.container <<'EOF'
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

cat > /home/student/.config/containers/systemd/qv-ui.container <<'EOF'
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

## Explanation
Unlike `podman compose up -d`, which requires extra systemd wrappers to survive host reboots, native Quadlets give every tier its own systemd unit, journal logs, restart policy, dependency graph, and automatic boot startup!

## Common Mistakes
- Forgetting `uid=1001,mode=0400` on `Secret=qv_db_pass,type=mount,...` inside `qv-api.container`.
