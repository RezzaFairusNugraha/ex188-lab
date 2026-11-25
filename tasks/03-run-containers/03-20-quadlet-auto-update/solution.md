## Solution
```bash
sudo tee /etc/containers/registries.conf.d/50-autoupdate.conf >/dev/null <<'EOF'
[[registry]]
location = "registry.lab.local:5000"
insecure = true
EOF

mkdir -p /home/student/.config/containers/systemd
cat > /home/student/.config/containers/systemd/autoweb.container <<'EOF'
[Container]
Image=registry.lab.local:5000/ops/autoweb:prod
ContainerName=autoweb
PublishPort=8320:8080
AutoUpdate=registry

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user start autoweb.service

podman tag localhost/autoweb-stage:v2 registry.lab.local:5000/ops/autoweb:prod
podman push registry.lab.local:5000/ops/autoweb:prod
podman auto-update
```

## Explanation
Note you can also preview pending updates safely with `podman auto-update --dry-run` or enable periodic background updates via `systemctl --user enable --now podman-auto-update.timer`!

## Common Mistakes
- Using a short image name instead of a fully qualified `registry/ns/repo:tag` — `AutoUpdate=registry` refuses short names!
