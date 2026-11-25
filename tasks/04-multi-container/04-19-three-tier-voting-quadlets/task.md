# Task 04-19: Full 3-Tier stack-voting Deployment as Reboot-Persistent Quadlet Services

## Scenario
Deploy the entire 3-tier `stack-voting` application **without Compose**, using pure Podman v5 Quadlets (`~/.config/containers/systemd/`) so every tier (`qv-db`, `qv-cache`, `qv-api`, `qv-ui`), network (`qv-net.network`), volume (`qv-pg.volume`, `qv-ballots.volume`), and Podman secret (`Secret=qv_db_pass,...`) comes up automatically after reboot!

## Requirements
1. Build `localhost/qv-ui:1.0` and `localhost/qv-api:1.0` from `/home/student/apps/stack-voting/`.
2. Create Podman secret `qv_db_pass` (`QuadletVote_0419`).
3. Author Quadlet units in `~/.config/containers/systemd/`:
   - `qv-net.network` (`NetworkName=qv-net`)
   - `qv-pg.volume` (`VolumeName=qv-pg`) and `qv-ballots.volume` (`VolumeName=qv-ballots`)
   - `qv-db.container` (PostgreSQL 16, `Secret=qv_db_pass,type=env,target=POSTGRESQL_PASSWORD`, `POSTGRESQL_USER=voteuser`, `POSTGRESQL_DATABASE=votesdb`)
   - `qv-cache.container` (Redis 7)
   - `qv-api.container` (`DB_HOST=qv-db`, `CACHE_HOST=qv-cache`, `Secret=qv_db_pass,type=mount,target=/run/secrets/db_password,uid=1001,mode=0400`, `Requires=`/`After=` DB and Cache)
   - `qv-ui.container` (`PublishPort=8419:8080`, `API_BASE_URL=http://qv-api:4000`, `Requires=`/`After=qv-api.service`, `[Install] WantedBy=default.target`)
4. Start the Quadlet stack, enable user lingering, and verify `http://127.0.0.1:8419/healthz` returns `200 OK`!
