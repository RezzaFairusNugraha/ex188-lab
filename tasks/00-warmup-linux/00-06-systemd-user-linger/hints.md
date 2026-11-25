## Level 1 — Nudge
User-scoped units live in `~/.config/systemd/user/`, use `WantedBy=default.target` (not `multi-user.target`!), and require `loginctl enable-linger` to survive logout/reboot.

## Level 2 — Approach
Write `[Unit]`, `[Service]` (`ExecStart=/home/student/workspace/00-06/pulse.sh`, `Restart=always`), and `[Install]` (`WantedBy=default.target`) into `~/.config/systemd/user/ex188-pulse.service`. Run `systemctl --user daemon-reload`, `systemctl --user enable --now ex188-pulse.service`, and `loginctl enable-linger student`.

## Level 3 — Key Commands
```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/ex188-pulse.service <<'EOF'
[Unit]
Description=EX188 Pulse Heartbeat Service

[Service]
ExecStart=/home/student/workspace/00-06/pulse.sh
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable --now ex188-pulse.service
sudo loginctl enable-linger student
```
