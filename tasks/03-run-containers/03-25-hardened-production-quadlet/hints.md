## Level 1 — Nudge
Check `man podman-systemd.unit` for native `[Container]` keys: `ReadOnly=true`, `Tmpfs=`, `DropCapability=ALL`, and `NoNewPrivileges=true`!

## Level 2 — Approach
1. Install `/opt/ex188-lab/certs/ca.crt` to `/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt`.
2. Pull `:1.0` and inspect `{{.Digest}}`.
3. Author `prod-metrics.container` with all hardening directives, reload/start `prod-metrics.service`, enable linger, and open `9325/tcp` in `firewalld`.

## Level 3 — Key Commands
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
podman pull secure-reg.lab.local:5443/prod/metrics-agent:1.0
DIG=$(podman image inspect --format '{{.Digest}}' secure-reg.lab.local:5443/prod/metrics-agent:1.0)

mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/prod-metrics.container <<EOF
[Container]
Image=secure-reg.lab.local:5443/prod/metrics-agent@${DIG}
ContainerName=prod-metrics
PublishPort=9325:9090
Environment=SERVICE_NAME=prod-node-01
ReadOnly=true
Tmpfs=/tmp:rw,noexec,nosuid,size=32m
DropCapability=ALL
NoNewPrivileges=true

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user start prod-metrics.service
loginctl enable-linger student
sudo firewall-cmd --permanent --add-port=9325/tcp && sudo firewall-cmd --reload
```
