# Task 03-22: Migrating a Deprecated podman generate systemd Unit to Podman v5 Quadlet

## Scenario
`podman generate systemd` is **deprecated** in Podman v5 and emits a deprecation warning recommending **Quadlet** (`podman-systemd.unit(5)`). Setup placed an old hand-generated `~/.config/systemd/user/container-legacy-cache.service` unit running `docker.io/library/redis:7-alpine` on `127.0.0.1:16379->6379` with `--memory 128m` and volume `legacy-redis-data:/data`.

## Requirements
1. Stop, disable, and delete the legacy unit file `~/.config/systemd/user/container-legacy-cache.service` (while **preserving** the existing Podman volume `legacy-redis-data` and its stored keys!).
2. Replace it with a native Podman v5 Quadlet at `~/.config/containers/systemd/legacy-cache.container` preserving all runtime settings:
   - `Image=docker.io/library/redis:7-alpine`
   - `ContainerName=legacy-cache`
   - `PublishPort=127.0.0.1:16379:6379`
   - `Volume=legacy-redis-data:/data`
   - `PodmanArgs=--memory=128m`
   - `[Service]` `Restart=always`, `[Install]` `WantedBy=default.target`
3. Reload user systemd, start `legacy-cache.service`, and verify the pre-existing Redis key `MIGRATION_CHECK` still returns `PRESERVED_99`!
