# Red Hat EX188 Full Mock Exam 01 — Commerce & Registry Promotion
- **Time Limit**: 150 Minutes
- **Total Score**: 300 Points (Passing Score: **210 / 300 — 70%**)
- **Primary User**: `student` (use `sudo` only where host/system configuration requires it)
- **Persistence Rule**: Every service, firewall port, registry credential, and SELinux context MUST survive a full system reboot without manual intervention. Run `sudo systemctl reboot` followed by `lab exam check-reboot` before `lab exam grade`!
- **Vendor Code Rule**: Do **not** modify application source files in `/home/student/apps/*`.

---

## Section A — Registry Trust & Base Image Management (60 pts)
- **Task 01 (15 pts)**: Configure `/etc/containers/certs.d/` so Podman trusts `/opt/ex188-lab/certs/ca.crt` for **both** `secure-reg.lab.local:5443` and `auth-reg.lab.local:5444` (do NOT mark either insecure), and configure `/etc/containers/registries.conf.d/50-m01.conf` marking `registry.lab.local:5000` as `insecure = true`.
- **Task 02 (15 pts)**: Log in to `auth-reg.lab.local:5444` (`student` / `redhat123`) storing persistent credentials in `/home/student/.config/containers/auth.json`.
- **Task 03 (15 pts)**: Query `https://auth-reg.lab.local:5444/v2/_catalog` via `curl` (with CA verification) and save the JSON response to `/home/student/workspace/m01/auth-catalog.json`.
- **Task 04 (15 pts)**: Promote pre-seeded `registry.lab.local:5000/m01-seed/ubi-base:1.0` to `secure-reg.lab.local:5443/m01/ubi-base:1.0` and `secure-reg.lab.local:5443/m01/ubi-base:latest`.

## Section B — Containerfile Implementation (75 pts)
- **Task 05 (15 pts)**: In `/home/student/workspace/m01/portal-build/`, write a `Containerfile` starting from `quay.io/nginx/nginx-unprivileged:1.26-alpine` that copies `/home/student/apps/static-portal/conf/nginx.conf` (`0644`) and `public/`, sets `LABEL com.exam.suite="mock-01"`, exposes `8080`, and builds `localhost/m01-portal:1.0`.
- **Task 06 (15 pts)**: In `/home/student/workspace/m01/flask-build/`, package `/home/student/apps/webapp-flask/` (unmodified `app.py`) on `secure-reg.lab.local:5443/m01/ubi-base:1.0` (with `python3` from `ubi10/ubi:latest` or `ubi-minimal` `microdnf install -y python3 && microdnf clean all`), `WORKDIR /opt/webapp`, `/var/lib/webapp/data` writable by `1001:0` (`g=u`), `.containerignore` excluding `*.secret`, `USER 1001`, exec-form `CMD`, built as `localhost/m01-webapp:1.0`.
- **Task 07 (15 pts)**: Tag and push both `localhost/m01-portal:1.0` and `localhost/m01-webapp:1.0` into `auth-reg.lab.local:5444/m01/portal:1.0` and `auth-reg.lab.local:5444/m01/webapp:1.0`.
- **Task 08 (15 pts)**: In `/home/student/workspace/m01/metrics-build/`, build multi-stage Go image `localhost/m01-metrics:1.0` from `/home/student/apps/metrics-go/` (`CGO_ENABLED=0` static binary `/usr/local/bin/metrics-agent` on `ubi10/ubi-minimal:latest`, `USER 1001`, no Go compiler in final stage) and push to `secure-reg.lab.local:5443/m01/metrics:1.0`.
- **Task 09 (15 pts)**: Save `localhost/m01-metrics:1.0` as an **`oci-archive`** tarball at `/home/student/workspace/m01/metrics-oci.tar`.

## Section C — Running Single Containers & Quadlet Persistence (60 pts)
- **Task 10 (15 pts)**: Create `/home/student/workspace/m01/portal-config.js` (`0644`) containing `banner: "Mock-01 Live Portal"` and deploy rootless Quadlet `~/.config/containers/systemd/m01-portal.container` running `auth-reg.lab.local:5444/m01/portal:1.0` (`ContainerName=m01-portal`, `PublishPort=18101:8080`, mounting `portal-config.js` read-only at `/usr/share/nginx/html/config.js:ro,Z`, `WantedBy=default.target`).
- **Task 11 (15 pts)**: Permanently open TCP ports `18101/tcp`, `18102/tcp`, and `18103/tcp` in `firewalld` and reload, and ensure `loginctl enable-linger student` is active.
- **Task 12 (15 pts)**: Deploy rootless Quadlet `~/.config/containers/systemd/m01-metrics.container` running `secure-reg.lab.local:5443/m01/metrics:1.0` (`ContainerName=m01-metrics`, `PublishPort=18102:9090`, `Environment=SERVICE_NAME=m01-edge`, `ReadOnly=true`, `DropCapability=ALL`, `PodmanArgs=--memory=128m`, `WantedBy=default.target`).
- **Task 13 (15 pts)**: Extract `m01-metrics`'s `State.Pid`, `Config.User`, and `HostConfig.Memory` using `podman inspect --format` into `/home/student/workspace/m01/metrics-inspect.env` (`PID=...`, `USER=...`, `MEMORY=...`).

## Section D — Multi-Container Workloads (60 pts)
- **Task 14 (15 pts)**: Create Podman secret `m01_web_sec` (`M01Secret_771`) and host directory `/home/student/workspace/m01/notes-data` (writable by UID `1001` via `keep-id` or `podman unshare chown` + `:Z`).
- **Task 15 (15 pts)**: Deploy a reboot-persistent **Quadlet `.pod` stack** (`m01-app.pod` on `PublishPort=18103:8080`, `m01-redis.container` running `docker.io/library/redis:7-alpine`, and `m01-web.container` running `auth-reg.lab.local:5444/m01/webapp:1.0` with `APP_ENV=production`, `REQUIRE_SECRET=1`, `CHECK_STORAGE=1`, `REDIS_HOST=127.0.0.1`, mounting `m01_web_sec` at `/run/secrets/webapp_secret` and `/home/student/workspace/m01/notes-data` at `/var/lib/webapp/data:Z`).
- **Task 16 (15 pts)**: Post `mock01-note-ok` to `http://127.0.0.1:18103/entries` and export running pod `m01-app` via `podman kube generate` to `/home/student/workspace/m01/m01-app-pod.yaml`.
- **Task 17 (15 pts)**: *(Compose task — 1 max)* In `/home/student/workspace/m01/compose-stack/compose.yaml`, deploy `m01-pg` (`quay.io/sclorg/postgresql-16-c10s:latest`, named volume `m01-pgvol:/var/lib/pgsql/data`, `POSTGRESQL_USER=m01u`, `POSTGRESQL_PASSWORD=m01p`, `POSTGRESQL_DATABASE=m01db`) and `m01-api` (`localhost/m01-api:1.0` built from `/home/student/apps/api-express/`, publishing `18104:3000`) on custom network `m01-cnet`.

## Section E — Troubleshooting Pre-Broken Workloads (45 pts)
- **Task 18 (10 pts)**: Fix crashed container `m01-broken-126` (exit code `126` on `/home/student/workspace/m01/broken-126/`) so it stays running.
- **Task 19 (10 pts)**: Fix `m01-broken-port` (running `nginx-unprivileged` but unreachable on required host port `18105` due to wrong port mapping `18105->80`).
- **Task 20 (10 pts)**: Fix invisible Quadlet `~/.config/systemd/user/m01-lost.container` (misplaced directory + invalid key `Ports=18106:8080`) so `m01-lost.service` is active and persistent on `18106`.
- **Task 21 (10 pts)**: Fix `m01-oom-worker` (exited with `137` / `OOMKilled=true` at `10m`) by recreating it with `--memory 128m --memory-swap 128m` so it stays running.
- **Task 22 (5 pts)**: Prune dangling `<none>` images created by setup (`m01-dangling`) without stopping any active exam container, and save `podman system df` output to `/home/student/workspace/m01/df.txt`.
