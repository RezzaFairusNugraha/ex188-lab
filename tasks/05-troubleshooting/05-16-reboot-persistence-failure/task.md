# Task 05-16: Troubleshooting Rootless Service Failure Across Logout and Reboot

## Objective
Rootless Quadlet service `critical-api.service` (`~/.config/containers/systemd/critical-api.container`, publishing `8516:8080`) starts manually when `systemctl --user start critical-api.service` is executed, but terminates on user logout and fails to start automatically after a system reboot.

## Specification
Inspect the host user configuration and `~/.config/containers/systemd/critical-api.container`, then fix every persistence defect so:
1. `critical-api.container` uses the valid `[Install]` target required by `systemd --user` boot startup.
2. User systemd services for `student` start at boot without requiring an active login session.
3. `critical-api.service` is active and `http://127.0.0.1:8516/` responds `200 OK`.
