## Solution
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt

podman pull secure-reg.lab.local:5443/prod/metrics-agent:1.0
DIG="$(podman image inspect --format '{{.Digest}}' secure-reg.lab.local:5443/prod/metrics-agent:1.0)"

mkdir -p /home/student/.config/containers/systemd
cat > /home/student/.config/containers/systemd/prod-metrics.container <<EOF
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
sudo firewall-cmd --permanent --add-port=9325/tcp
sudo firewall-cmd --reload
```

## Explanation
Every security option from `podman run` maps cleanly to first-class Quadlet directives documented in `man podman-systemd.unit` (`ReadOnly=`, `Tmpfs=`, `DropCapability=`, `NoNewPrivileges=`).

## Common Mistakes
- Putting systemd's own `NoNewPrivileges=` under `[Service]` instead of Quadlet's `NoNewPrivileges=true` under `[Container]`.
