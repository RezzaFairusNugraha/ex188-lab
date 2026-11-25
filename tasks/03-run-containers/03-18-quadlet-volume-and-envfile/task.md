# Task 03-18: Quadlet .container Coupled with a .volume Unit and EnvironmentFile

## Scenario
Quadlet `.volume` units (`~/.config/containers/systemd/*.volume`) let systemd automatically create and mount named Podman volumes before starting a `.container` unit!

## Requirements
As user `student`:
1. Create Quadlet volume unit `~/.config/containers/systemd/notes-store.volume` (`[Volume]` section, `VolumeName=notes-store`).
2. Create `/home/student/workspace/03-18/webapp.env` setting `APP_ENV=production` and `APP_PORT=8080`.
3. Create `~/.config/containers/systemd/notes-quad.container` running pre-built `localhost/webapp-0318:1.0`:
   - `ContainerName=notes-quad`
   - `PublishPort=8318:8080`
   - `EnvironmentFile=/home/student/workspace/03-18/webapp.env`
   - `Volume=notes-store.volume:/var/lib/webapp/data`
   - `[Install]` `WantedBy=default.target`
4. Reload user systemd, start `notes-quad.service`, and post `quadlet-vol-ok` to `http://127.0.0.1:8318/entries`.
