## Solution
```bash
sed -i 's/^WantedBy=multi-user\.target$/WantedBy=default.target/' \
  /home/student/.config/containers/systemd/critical-api.container

systemctl --user daemon-reload
systemctl --user restart critical-api.service
sudo loginctl enable-linger student
```

## Explanation
`multi-user.target` exists ONLY in the system-wide (`PID 1`) systemd manager — inside `systemd --user`, `WantedBy=multi-user.target` never fires at boot! Rootless Quadlets **must** use `WantedBy=default.target` AND `loginctl enable-linger`.

## Common Mistakes
- Fixing `loginctl enable-linger` while overlooking `WantedBy=multi-user.target` in the user Quadlet!
