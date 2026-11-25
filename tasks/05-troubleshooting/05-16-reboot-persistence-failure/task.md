# Task 05-16: Services Vanish on Logout/Reboot: Fixing Missing Linger and Quadlet [Install] Target

## Scenario
`critical-api.service` (`~/.config/containers/systemd/critical-api.container` on `-p 8516:8080`) runs fine right after `systemctl --user start critical-api.service`, yet every time the VM reboots or `student` logs out of SSH, the container stops and never comes back at boot!

## Requirements
Inspect `~/.config/containers/systemd/critical-api.container` and `loginctl show-user student -p Linger`, then fix **every** persistence defect so:
1. `critical-api.container` has a valid `[Install]` section targeting `default.target` (note: fix the wrong `WantedBy=multi-user.target` currently inside the user Quadlet!).
2. `systemctl --user daemon-reload` and `critical-api.service` are active.
3. User lingering is enabled for `student` (`Linger=yes`).
