# Red Hat EX188 Full Mock Exam 02 — Hardened Telemetry & Kube Workloads (Zero Compose)
- **Time Limit**: 150 Minutes
- **Total Score**: 300 Points (Passing Score: **210 / 300 — 70%**)
- **Primary User**: `student` (zero `podman compose` required — pure Podman, Pods, `kube play`, and Quadlets!)

---

## Section A — Registry Mirroring, Digests & Transports (60 pts)
- **Task 01 (15 pts)**: Install `/opt/ex188-lab/certs/ca.crt` for `secure-reg.lab.local:5443` and `auth-reg.lab.local:5444`, and log in to `:5444` (`ci-bot` / `Ex188Pass!`) persisting `/home/student/.config/containers/auth.json`.
- **Task 02 (15 pts)**: Configure `/etc/containers/registries.conf.d/60-m02-mirror.conf` mapping `prefix = "mirror-ext.corp.local"` to `[[registry.mirror]]` `location = "secure-reg.lab.local:5443"`, and pull `mirror-ext.corp.local/m02/ubi-minimal:latest`.
- **Task 03 (15 pts)**: Ingest pre-staged `dir:/home/student/workspace/m02/seed-dir` via `podman pull`, tag it `auth-reg.lab.local:5444/m02/seed-tool:1.0`, and push to `:5444`.
- **Task 04 (15 pts)**: Inspect the remote manifest of `auth-reg.lab.local:5444/m02/seed-tool:1.0` via `podman manifest inspect` and save it to `/home/student/workspace/m02/seed-manifest.json`.

## Section B — Containerfile Engineering & Security (75 pts)
- **Task 05 (15 pts)**: Build `localhost/m02-worker:1.0` from `/home/student/apps/worker-py/` (staged in `/home/student/workspace/m02/worker-build/`) using `ubi10/ubi:latest`, single `RUN` layer (`dnf clean all`), `USER 1001`, `--format docker` `HEALTHCHECK` (`python3 /opt/worker/healthcheck.py`), exec `ENTRYPOINT ["python3", "/opt/worker/worker.py"]` and `CMD ["--interval", "2"]`.
- **Task 06 (15 pts)**: Build `localhost/m02-api:1.0` from `/home/student/apps/api-express/` (staged in `/home/student/workspace/m02/api-build/`) with arbitrary-UID group `0` permissions (`1001:0`, `g=u` on `/var/lib/api-express/audit`), `USER 1001`, and push to `auth-reg.lab.local:5444/m02/api:1.0`.
- **Task 07 (15 pts)**: Build `localhost/m02-secret-build:1.0` in `/home/student/workspace/m02/sec-build/` mounting build secret `/home/student/workspace/m02/build.key` (`--secret id=bkey,...`) to write its SHA256 digest into `/etc/bkey.sha256` with **zero** raw secret trace in `podman history`.
- **Task 08 (15 pts)**: Refactor `/home/student/workspace/m02/legacy-cf/Containerfile` (remove baked `API_SECRET`, switch shell `CMD` to exec `CMD`, consolidate `RUN`, set `USER 1001`) and build `localhost/m02-webapp:2.0`, pushing to `secure-reg.lab.local:5443/m02/webapp:2.0`.
- **Task 09 (15 pts)**: Flatten a temporary container of `localhost/m02-worker:1.0` using `podman export` + `podman import --change 'USER 1001' --change 'CMD ["python3", "/opt/worker/worker.py"]'` into `localhost/m02-worker-flat:1.0` (1 layer).

## Section C — Low Ports, Events, Logs & System/User Quadlets (60 pts)
- **Task 10 (15 pts)**: Configure persistent `/etc/sysctl.d/90-m02-lowport.conf` setting `net.ipv4.ip_unprivileged_port_start = 800`, apply it, and permanently open `820/tcp`, `18201/tcp`, and `18202/tcp` in `firewalld`.
- **Task 11 (15 pts)**: Deploy rootless Quadlet `~/.config/containers/systemd/m02-lowedge.container` running `quay.io/nginx/nginx-unprivileged:1.26-alpine` on privileged host port **`820:8080`** (`ContainerName=m02-lowedge`, `WantedBy=default.target`, linger enabled).
- **Task 12 (15 pts)**: Deploy **rootful system Quadlet** `/etc/containers/systemd/m02-sys-worker.container` running `localhost/m02-worker:1.0` *(push/load into rootful or pull from `:5443` after pushing `secure-reg.lab.local:5443/m02/worker:1.0`!)* with `ContainerName=m02-sys-worker` and `WantedBy=multi-user.target`.
- **Task 13 (15 pts)**: Capture `start` event of `m02-lowedge` using `podman events --since 60m --stream=false --filter container=m02-lowedge --filter event=start` into `/home/student/workspace/m02/lowedge-events.log`.

## Section D — Multi-Container Pods & Quadlet .kube Stacks (60 pts)
- **Task 14 (15 pts)**: Create Podman secret `m02_api_tok` (`M02ApiTok_991`) and Quadlet units `m02-net.network`, `m02-audit.volume`, and `m02-api.container` (`PublishPort=18201:3000`, `AUTH_REQUIRED=true`, `Secret=m02_api_tok,type=mount,target=/run/secrets/api_token,uid=1001,mode=0400`, `Volume=m02-audit.volume:/var/lib/api-express/audit`, `WantedBy=default.target`).
- **Task 15 (15 pts)**: Post an authenticated audit record to `http://127.0.0.1:18201/api/v1/audit` (`X-API-Token: M02ApiTok_991`).
- **Task 16 (15 pts)**: Author `/home/student/workspace/m02/kube-cm.yaml` (`ConfigMap` `m02-cm`: `SITE_TITLE=M02 Kube Stack`) and `/home/student/workspace/m02/kube-pod.yaml` (`Pod` `m02-kpod`: `redis:7-alpine` + `secure-reg.lab.local:5443/m02/webapp:2.0` on `hostPort: 18202` -> `8080`, `APP_ENV=production`, `REDIS_HOST=127.0.0.1`, mounting `m02-cm` at `/etc/webapp/app.conf`).
- **Task 17 (15 pts)**: Persist the Kubernetes stack across reboot via `~/.config/containers/systemd/m02-kube.kube` (`Yaml=...`, `ConfigMap=...`, `WantedBy=default.target`) and start `m02-kube.service`.

## Section E — Troubleshooting & Inspection (45 pts)
- **Task 18 (10 pts)**: Fix `m02-selinux-fail` (`18205:8080`) where `/home/student/workspace/m02/se-data` lacks SELinux relabeling and UID mapping (`keep-id:uid=1001,gid=1001` + `:Z`) without disabling SELinux!
- **Task 19 (10 pts)**: Fix `m02-bad-hc` (`nginx-unprivileged` marked `unhealthy` because `--health-cmd` probes `:80` instead of `:8080` on `18206:8080`).
- **Task 20 (10 pts)**: Fix `m02-db-loss` (`postgresql-16-c10s` mounting `m02-pgvol` at wrong path `/var/lib/postgresql/data` instead of `/var/lib/pgsql/data`).
- **Task 21 (10 pts)**: Export pre-running `m02-fixme-pod` via `podman kube generate` to `/home/student/workspace/m02/fixed-pod.yaml`, change `hostPort` to `18207` and `memory` limit to `128Mi`, and redeploy via `podman kube play`.
- **Task 22 (5 pts)**: Write the Mountpoint of `m02-pgvol` (`VOL_PATH=...`) and Subnet of `m02-net` (`SUBNET=...`) into `/home/student/workspace/m02/inspect-report.env`.
