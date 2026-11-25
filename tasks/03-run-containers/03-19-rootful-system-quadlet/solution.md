## Solution
```bash
sudo mkdir -p /etc/containers/systemd
sudo tee /etc/containers/systemd/sys-gateway.container >/dev/null <<'EOF'
[Unit]
Description=System Gateway Quadlet

[Container]
Image=quay.io/nginx/nginx-unprivileged:1.26-alpine
ContainerName=sys-gateway
PublishPort=8089:8080

[Service]
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo /usr/lib/systemd/system-generators/podman-system-generator --dryrun
sudo systemctl daemon-reload
sudo systemctl start sys-gateway.service
sudo firewall-cmd --permanent --add-port=8089/tcp
sudo firewall-cmd --reload
```

## Explanation
Compare the two Quadlet scopes carefully:
- **Rootless (`student`)**: `~/.config/containers/systemd/` | `WantedBy=default.target` | `systemctl --user` | requires `linger`.
- **Rootful (`root`)**: `/etc/containers/systemd/` | `WantedBy=multi-user.target` | `sudo systemctl` | runs at OS boot with no linger needed.

## Common Mistakes
- Putting a rootful Quadlet in `/root/.config/containers/systemd/` instead of `/etc/containers/systemd/`!
