## Solution
```bash
cp -r /home/student/apps/webapp-flask/. /home/student/workspace/03-21/build/
cat > /home/student/workspace/03-21/build/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/webapp /var/lib/webapp/data \
    && chown -R 1001:0 /opt/webapp /var/lib/webapp \
    && chmod -R g=u /var/lib/webapp \
    && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF

podman build -t localhost/acme-status:1.0 /home/student/workspace/03-21/build

cat > /home/student/workspace/03-21/app.conf <<'EOF'
SITE_TITLE=Quadlet Operations Hub
SUPPORT_TEAM=noc@acme.local
EOF
chmod 0644 /home/student/workspace/03-21/app.conf

mkdir -p /home/student/.config/containers/systemd
cat > /home/student/.config/containers/systemd/acme-status.container <<'EOF'
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

## Explanation
Note `chmod 0644` on `app.conf`! Because `student` maps to UID `0` inside the container while `app.py` runs as UID `1001`, world-read (`o+r`) allows UID `1001` to read the mounted config file cleanly without needing `keep-id`.

## Common Mistakes
- Creating `app.conf` under `umask 0077` (`0600`), preventing container UID `1001` from reading `/etc/webapp/app.conf`.
