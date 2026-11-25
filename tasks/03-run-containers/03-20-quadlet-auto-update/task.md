# Task 03-20: Rolling Registry Updates with Quadlet AutoUpdate=registry and podman auto-update

## Scenario
`podman auto-update` inspects running systemd/Quadlet containers labeled with `AutoUpdate=registry` (`io.containers.autoupdate=registry`), checks if the remote registry tag points to a newer digest, pulls the update, and restarts the systemd unit automatically!

Setup published `v1` of `registry.lab.local:5000/ops/autoweb:prod` (serving `REL-V1`) and staged a `v2` image locally (`localhost/autoweb-stage:v2`, serving `REL-V2`).

## Requirements
1. Ensure `registry.lab.local:5000` is marked `insecure = true` in `/etc/containers/registries.conf.d/50-autoupdate.conf` so Quadlet pulls from `:5000` cleanly.
2. Create rootless Quadlet `~/.config/containers/systemd/autoweb.container` running `registry.lab.local:5000/ops/autoweb:prod` on `PublishPort=8320:8080` with `AutoUpdate=registry` inside `[Container]` and `WantedBy=default.target` inside `[Install]`.
3. Start `autoweb.service` and confirm `http://127.0.0.1:8320/` initially returns `REL-V1`.
4. Tag `localhost/autoweb-stage:v2` as `registry.lab.local:5000/ops/autoweb:prod`, push it to `:5000`, and run `podman auto-update` so `autoweb.service` rolls forward automatically and `http://127.0.0.1:8320/` returns `REL-V2`!
