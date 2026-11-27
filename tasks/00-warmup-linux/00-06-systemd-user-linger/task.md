# Task 00-06: Rootless systemd --user Service and User Lingering

## Objective
A helper script `/home/student/workspace/00-06/pulse.sh` has been placed in your workspace.

## Specification
As user `student`:
1. Create a user systemd unit at `~/.config/systemd/user/ex188-pulse.service` that runs `/home/student/workspace/00-06/pulse.sh` (`Restart=always`, `WantedBy=default.target`).
2. Reload the user systemd manager, enable `ex188-pulse.service`, and start it immediately.
3. Ensure user lingering (`loginctl enable-linger`) is enabled for `student` so user services start automatically on system reboot even before `student` logs in.
4. Verify `/home/student/workspace/00-06/pulse.log` is created by the running service.
