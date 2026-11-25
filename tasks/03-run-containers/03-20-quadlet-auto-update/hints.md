## Level 1 — Nudge
`podman auto-update` ONLY works on containers managed by systemd with a fully qualified `Image=` reference and `AutoUpdate=registry` in the `[Container]` section!

## Level 2 — Approach
1. Configure `/etc/containers/registries.conf.d/50-autoupdate.conf` (`insecure = true` for `registry.lab.local:5000`).
2. Create `autoweb.container` with `AutoUpdate=registry`, `daemon-reload`, and start `autoweb.service`.
3. Tag `localhost/autoweb-stage:v2` -> `registry.lab.local:5000/ops/autoweb:prod`, `podman push`, and run `podman auto-update`.

## Level 3 — Key Commands
```bash
sudo tee /etc/containers/registries.conf.d/50-autoupdate.conf >/dev/null <<'EOF'
[[registry]]
location = "registry.lab.local:5000"
insecure = true
EOF

mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/autoweb.container <<'EOF'
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
