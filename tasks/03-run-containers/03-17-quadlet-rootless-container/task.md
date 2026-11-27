# Task 03-17: Persistent Rootless Service with Quadlet (.container) and Lingering

## Objective
On RHEL 10 with Podman v5, **Quadlet** (`~/.config/containers/systemd/*.container`) is the standard, exam-tested way to run containers as reboot-persistent systemd services!

> **CRITICAL Podman v5 Quadlet Rule**: Generated Quadlet units cannot be enabled with `systemctl --user enable <name>.service` (`unit is transient or generated`). Instead, adding `WantedBy=default.target` under `[Install]` inside the `.container` file causes `podman-system-generator` to wire boot auto-start automatically upon `systemctl --user daemon-reload`!

## Specification
As user `student`:
1. Create `/home/student/.config/containers/systemd/portal-quad.container` running:
   - `Image=quay.io/nginx/nginx-unprivileged:1.26-alpine`
   - `ContainerName=portal-quad`
   - `PublishPort=8317:8080` (`${HOST_PORT}:8080` if `--seed` is active)
   - `[Service]` `Restart=always`
   - `[Install]` `WantedBy=default.target`
2. Validate syntax with `/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun`, run `systemctl --user daemon-reload`, start `portal-quad.service`, and ensure `loginctl enable-linger student` is active.
