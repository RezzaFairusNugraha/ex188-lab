# Task 03-21: Deploying Vendor App webapp-flask as a Persistent Quadlet Service from README

## Scenario
Read `/home/student/apps/webapp-flask/README.md`. Build and deploy `webapp-flask` as a persistent rootless Quadlet service with externalized `app.conf` configuration — without modifying `app.py`.

## Requirements
1. Build `localhost/acme-status:1.0` from `/home/student/apps/webapp-flask/` (staged in `/home/student/workspace/03-21/build/`) as non-root `USER 1001`.
2. Create `/home/student/workspace/03-21/app.conf` containing `SITE_TITLE=Quadlet Operations Hub` and `SUPPORT_TEAM=noc@acme.local`.
3. Create `~/.config/containers/systemd/acme-status.container`:
   - `ContainerName=acme-status`
   - `PublishPort=8321:8080` (`${HOST_PORT}:8080` if `--seed` is active)
   - `Environment=APP_ENV=production` and `Environment=REQUIRE_STRICT_ENV=1`
   - Read-only bind mount of `app.conf` at `/etc/webapp/app.conf:ro,Z`
   - `[Service]` `Restart=always`, `[Install]` `WantedBy=default.target`
4. Start `acme-status.service` and ensure user lingering is enabled.
