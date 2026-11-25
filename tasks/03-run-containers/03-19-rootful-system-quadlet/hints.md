## Level 1 — Nudge
System Quadlets live in `/etc/containers/systemd/`, use `WantedBy=multi-user.target` (NOT `default.target` alone, though `multi-user.target` is canonical for system services), and require `sudo systemctl` without `--user`.

## Level 2 — Approach
Write `/etc/containers/systemd/sys-gateway.container`, run `sudo systemctl daemon-reload && sudo systemctl start sys-gateway.service`, and open `8089/tcp` in `firewalld`.

## Level 3 — Key Commands
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
sudo systemctl daemon-reload
sudo systemctl start sys-gateway.service
sudo firewall-cmd --permanent --add-port=8089/tcp && sudo firewall-cmd --reload
```
