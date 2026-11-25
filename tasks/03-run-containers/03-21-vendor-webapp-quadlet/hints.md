## Level 1 — Nudge
Read `~/apps/webapp-flask/README.md` for `CONFIG_PATH` (`/etc/webapp/app.conf`) and Quadlet `Environment=` + `Volume=` keys in `man podman-systemd.unit`.

## Level 2 — Approach
Build `localhost/acme-status:1.0`, write `~/workspace/03-21/app.conf` (`chmod 0644`!), create `acme-status.container` mounting `Volume=/home/student/workspace/03-21/app.conf:/etc/webapp/app.conf:ro,Z`, `daemon-reload`, and `start acme-status.service`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/webapp-flask/. ~/workspace/03-21/build/
cat > ~/workspace/03-21/build/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp /var/lib/webapp/data && chown -R 1001:0 /opt/webapp /var/lib/webapp && chmod -R g=u /var/lib/webapp && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -t localhost/acme-status:1.0 ~/workspace/03-21/build

cat > ~/workspace/03-21/app.conf <<'EOF'
SITE_TITLE=Quadlet Operations Hub
SUPPORT_TEAM=noc@acme.local
EOF
chmod 0644 ~/workspace/03-21/app.conf

mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/acme-status.container <<'EOF'
[Container]
Image=localhost/acme-status:1.0
ContainerName=acme-status
PublishPort=8321:8080
Environment=APP_ENV=production
Environment=REQUIRE_STRICT_ENV=1
Volume=/home/student/workspace/03-21/app.conf:/etc/webapp/app.conf:ro,Z

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user start acme-status.service
loginctl enable-linger student
```
