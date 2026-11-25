# Task 04-14: Linked Quadlet Stack: .network, .volume, and Dependent .container Units

## Scenario
Deploy a reboot-persistent two-container stack (`q-db` + `q-web`) connected over a Quadlet `.network` unit (`tier-net.network`) with database persistence on a Quadlet `.volume` unit (`tier-pg.volume`) and systemd ordering (`Requires=q-db.service`, `After=q-db.service`).

## Requirements
Inside `/home/student/.config/containers/systemd/`:
1. `tier-net.network` (`[Network]`, `NetworkName=tier-net`).
2. `tier-pg.volume` (`[Volume]`, `VolumeName=tier-pg`).
3. `q-db.container`: runs `quay.io/sclorg/postgresql-16-c10s:latest` (`ContainerName=q-db`, `Network=tier-net.network`, `Volume=tier-pg.volume:/var/lib/pgsql/data`, `POSTGRESQL_USER=quser`, `POSTGRESQL_PASSWORD=qpass`, `POSTGRESQL_DATABASE=qdb`, `[Install] WantedBy=default.target`).
4. `q-web.container`: runs `localhost/webapp-0414:1.0` (`ContainerName=q-web`, `Network=tier-net.network`, `PublishPort=8414:8080`, `APP_ENV=production`, `DB_HOST=q-db`, `[Unit] Requires=q-db.service` + `After=q-db.service`, `[Install] WantedBy=default.target`).
5. Reload user systemd, start `q-web.service` (which must automatically pull up `q-db.service`!), and verify `http://127.0.0.1:8414/healthz` returns `200 OK`.
