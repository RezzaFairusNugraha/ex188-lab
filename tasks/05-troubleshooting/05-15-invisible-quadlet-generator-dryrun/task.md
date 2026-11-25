# Task 05-15: Quadlet Unit Invisible to systemctl --user: Debugging with podman-system-generator --dryrun

## Scenario
When a Quadlet `.container` file contains an invalid section header or unknown/misspelled key, `systemctl --user daemon-reload` succeeds **silently** with exit code `0`, yet `systemctl --user status broken-quad.service` says **`Unit broken-quad.service could not be found`!**

Setup placed a broken Quadlet in the wrong directory or with multiple syntax errors under `/home/student/.config/`. Use `/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun` to uncover every error!

## Requirements
1. Locate the misplaced/broken Quadlet file for `broken-quad` (`~/.config/systemd/user/broken-quad.container` -> move to `~/.config/containers/systemd/broken-quad.container`).
2. Run `/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun` and fix every syntax/key defect inside `broken-quad.container` (`quay.io/nginx/nginx-unprivileged:1.26-alpine` on `PublishPort=8515:8080`, `WantedBy=default.target`).
3. Reload `systemd --user`, start `broken-quad.service`, and verify `http://127.0.0.1:8515/` responds `200 OK`.
