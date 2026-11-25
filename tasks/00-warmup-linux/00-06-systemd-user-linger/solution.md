## Solution
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
loginctl enable-linger student
```

## Explanation
For `systemd --user`, the startup target is `default.target` (as opposed to system-wide `multi-user.target`). Without `loginctl enable-linger`, the user manager stops as soon as the last SSH session logs out and will not start on reboot.

## Common Mistakes
- Using `WantedBy=multi-user.target` inside a `--user` unit (`multi-user.target` does not exist in the per-user systemd instance!).
- Running `sudo systemctl --user ...` (never combine `sudo` with `--user`, as `XDG_RUNTIME_DIR` will not match).
