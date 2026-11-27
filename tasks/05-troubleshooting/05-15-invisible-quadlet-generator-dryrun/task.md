# Task 05-15: Troubleshooting an Invisible Quadlet Service Unit

## Objective
An administrator attempted to deploy a rootless Quadlet unit for `broken-quad`, but `systemctl --user status broken-quad.service` reports `Unit broken-quad.service could not be found` even after running `systemctl --user daemon-reload`.

## Specification
As user `student`:
1. Locate the misplaced Quadlet file under `/home/student/.config/`, move it to the correct rootless Quadlet search directory (removing the misplaced copy), and diagnose all unit syntax errors using the Podman systemd generator dry-run tool.
2. Repair `broken-quad.container` so it runs `quay.io/nginx/nginx-unprivileged:1.26-alpine` as container `broken-quad`, publishes host port `8515` to container port `8080`, and starts automatically at boot.
3. Reload `systemd --user`, start `broken-quad.service`, and verify `http://127.0.0.1:8515/` responds `200 OK`.
