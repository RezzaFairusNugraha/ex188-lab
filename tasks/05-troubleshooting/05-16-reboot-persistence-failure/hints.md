## Level 1 — Nudge
Check two classic rootless reboot killers: (1) `WantedBy=` target name inside a `--user` Quadlet (`default.target` vs `multi-user.target`!), and (2) `loginctl show-user student -p Linger`!

## Level 2 — Approach
Change `WantedBy=multi-user.target` to `WantedBy=default.target` in `~/.config/containers/systemd/critical-api.container`, run `systemctl --user daemon-reload`, restart `critical-api.service`, and run `sudo loginctl enable-linger student`.

## Level 3 — Key Commands
```bash
sed -i 's/^WantedBy=multi-user\.target$/WantedBy=default.target/' ~/.config/containers/systemd/critical-api.container
systemctl --user daemon-reload
systemctl --user restart critical-api.service
sudo loginctl enable-linger student
```
