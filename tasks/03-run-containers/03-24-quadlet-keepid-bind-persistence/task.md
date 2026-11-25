# Task 03-24: Rootless Quadlet with UserNS=keep-id and SELinux Host Bind Mount Persistence

## Scenario
Combine three critical EX188 objectives in a single service:
1. Rootless UID mapping (`UserNS=keep-id:uid=1001,gid=1001` in Quadlet)
2. Host directory bind mount (`/srv/student-journal` owned by `student:student`) with SELinux `:Z`
3. Reboot persistence (`~/.config/containers/systemd/journal-web.container` + `linger`)

## Requirements
1. Ensure `/srv/student-journal` exists and is owned by `student:student`.
2. Author `~/.config/containers/systemd/journal-web.container` running pre-built `localhost/webapp-0324:1.0` (which runs as `USER 1001`):
   - `ContainerName=journal-web`
   - `PublishPort=8324:8080`
   - `Environment=APP_ENV=production` and `Environment=CHECK_STORAGE=1`
   - `UserNS=keep-id:uid=1001,gid=1001`
   - `Volume=/srv/student-journal:/var/lib/webapp/data:Z`
   - `[Service]` `Restart=always`, `[Install]` `WantedBy=default.target`
3. Start `journal-web.service`, post `survived-restart-test` to `http://127.0.0.1:8324/entries`, restart `journal-web.service` via `systemctl --user restart`, and verify both `/healthz` (`200`) and `/srv/student-journal/entries.log` (owned by `student` on the host!) succeed.
