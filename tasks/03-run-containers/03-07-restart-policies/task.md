# Task 03-07: In-Process Container Restart Policies (--restart=on-failure:3 vs always)

## Scenario
Because Podman is daemonless, `--restart=always` or `--restart=on-failure` restarts crashed processes **within the current boot** via `conmon`, whereas **reboot persistence** requires systemd/Quadlet (`podman-restart.service` or `.container` Quadlet)! Here you will configure runtime `--restart` policies accurately.

## Requirements
1. Start detached container `retry-bounded` from `registry.access.redhat.com/ubi10/ubi-minimal:latest` with `--restart=on-failure:3` running `sleep 3600`.
2. Start detached container `retry-always` from `registry.access.redhat.com/ubi10/ubi-minimal:latest` with `--restart=always` running `sleep 3600`.
3. Enable `podman-restart.service` in `systemd --user` (`systemctl --user enable podman-restart.service`) and understand how it differs from native Quadlets.
