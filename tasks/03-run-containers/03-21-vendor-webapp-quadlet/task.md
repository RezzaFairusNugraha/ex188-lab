# Task 03-21: Deploying Vendor Application webapp-flask as a Persistent Quadlet Service

## Objective
The `webapp-flask` application and `README.md` have been pre-staged in `/home/student/workspace/03-21/build/`. Build the image and deploy it as a rootless systemd Quadlet service that starts automatically on system boot without modifying `app.py`.

## Specification
As user `student`:
1. Build `localhost/acme-status:1.0` from `/home/student/workspace/03-21/build/` on `registry.access.redhat.com/ubi10/ubi:latest` running as numeric `USER 1001`.
2. Create `/home/student/workspace/03-21/app.conf` (mode `0644`) containing:
   ```ini
   SITE_TITLE=Quadlet Operations Hub
   SUPPORT_TEAM=noc@acme.local
   ```
3. Create Quadlet unit `~/.config/containers/systemd/acme-status.container` running `localhost/acme-status:1.0`:
   - Container name: `acme-status`
   - Published port: `8321:8080` (`${HOST_PORT}:8080` if `--seed` is active)
   - Environment variables: `APP_ENV=production` and `REQUIRE_STRICT_ENV=1`
   - Mount `/home/student/workspace/03-21/app.conf` read-only at `/etc/webapp/app.conf` with SELinux relabeling
   - Configured to restart automatically (`Restart=always`) and start on boot (`WantedBy=default.target`)
4. Reload `systemd --user`, start `acme-status.service`, and ensure user lingering is enabled for `student`.
