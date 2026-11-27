# Red Hat EX188 Full Mock Exam 05 - Full-Spectrum Dress Rehearsal
- **Time Limit**: 150 minutes | **Total**: 300 points | **Pass**: 210 / 300 (70%)
- **User**: `student` (use `sudo` only for host/system configuration)
- **Persistence**: everything must survive a reboot with no manual action. Before `lab exam grade`, run `sudo systemctl reboot`, log in, then run `lab exam check-reboot`.
- **Vendor code**: never modify files under `/home/student/apps/*` (read each README.md).
- **Workspace**: `/home/student/workspace/m05/` (create sub-directories as needed).
- Tasks are chained: later tasks reuse images, registries and files from earlier ones.

- **Exam Environment Notes**:
  - When re-pushing a signed Red Hat base image (`ubi10/*`) directly without building, pass `--remove-signatures` to `podman push`.
  - When defining Quadlet `.volume`, `.network`, or `.pod` units, set explicit `VolumeName=`, `NetworkName=`, or `PodName=` keys if a specific Podman object name is requested.
  - Run `lab exam check-reboot` to verify Quadlet/firewall/linger boot persistence; if you perform a full `sudo systemctl reboot` before `lab exam grade`, ensure non-Quadlet containers were started with `--restart=always` (with `systemctl --user enable podman-restart.service`) or start them again before running `lab exam grade`.

---
### Task 01 (10 pts) - Registry trust and insecure HTTP registry
Trust the lab CA for `secure-reg.lab.local:5443` and `auth-reg.lab.local:5444` under `/etc/containers/certs.d/`; mark `registry.lab.local:5000` insecure in `/etc/containers/registries.conf.d/50-m05.conf`.

### Task 02 (10 pts) - Persistent login
Log in to `auth-reg.lab.local:5444` (`student` / `redhat123`) and persist credentials in `~/.config/containers/auth.json`.

### Task 03 (10 pts) - Registry mirror
Configure `/etc/containers/registries.conf.d/60-m05-mirror.conf` so `mirror-m05.corp.local` is served by mirror `secure-reg.lab.local:5443`, then pull `mirror-m05.corp.local/m05/core:1.0`.

### Task 04 (10 pts) - Offline transports
Import `m05/seed-dir` (a `dir:` image) as `localhost/m05-fromdir:1.0` and `m05/seed-oci.tar` (an `oci-archive`) as `localhost/m05-fromoci:1.0`.

### Task 05 (15 pts) - Web image with healthcheck
Build `localhost/m05-web:1.0` from `/home/student/workspace/m05/web-build (pre-staged webapp-flask)` (USER 1001, `HEALTHCHECK` using `python3 -c` against `/healthz`, built so the healthcheck is stored).

### Task 06 (15 pts) - Worker with ENTRYPOINT + CMD
Build `localhost/m05-worker:1.0` from `/home/student/workspace/m05/worker-build (pre-staged worker-py)`: exec-form `ENTRYPOINT ["python3","/opt/worker/worker.py"]` and default `CMD ["--interval","2","--prefix","M05"]`, USER 1001.

### Task 07 (15 pts) - Multi-stage Go image
Build `localhost/m05-metrics:1.0` from `/home/student/workspace/m05/metrics-build (pre-staged metrics-go)` (static binary, ubi-minimal runtime, USER 1001, no Go in the final image).

### Task 08 (10 pts) - Push images
Push `m05-web` and `m05-worker` to `auth-reg.lab.local:5444/m05/web:1.0` and `.../m05/worker:1.0`; push `m05-metrics` to BOTH `auth-reg.lab.local:5444/m05/metrics:1.0` and `secure-reg.lab.local:5443/m05/metrics:1.0`.

### Task 09 (10 pts) - Flatten with export/import
Export container `m05-legacybox` and import it as `localhost/m05-flat:1.0` with `USER 1001` and `CMD ["cat","/etc/stamp"]`.

### Task 10 (10 pts) - OCI archive
Save `localhost/m05-metrics:1.0` as an `oci-archive` tarball `m05/metrics-oci.tar`.

### Task 11 (10 pts) - Commit a container
Commit container `m05-hotfix` as `localhost/m05-hotfix:1.1` with `ENV HOTFIX=1.1`; the live change in `/etc/hotfix.conf` must be kept.

### Task 12 (15 pts) - Rootful system Quadlet
As root, deploy `auth`-free image `secure-reg.lab.local:5443/m05/metrics:1.0` with `/etc/containers/systemd/m05-sys-metrics.container` (`PublishPort=18501:9090`, `SERVICE_NAME=m05-sys`, `WantedBy=multi-user.target`).

### Task 13 (10 pts) - Persistent low-port sysctl
Persist `net.ipv4.ip_unprivileged_port_start = 780` in `/etc/sysctl.d/90-m05-lowport.conf`, apply it, and open `790/tcp` permanently.

### Task 14 (15 pts) - Rootless Quadlet on a privileged port
Rootless Quadlet `m05-edge.container` running nginx-unprivileged on host port `790` (container 8080), starting at boot.

### Task 15 (15 pts) - Web Quadlet with secret, volume and env file
Create secret `m05_web_sec` and deploy `auth-reg.lab.local:5444/m05/web:1.0` as `m05-web.container` on `18502:8080` with `EnvironmentFile` (`APP_ENV=production`, `REQUIRE_SECRET=1`), the secret at `/run/secrets/webapp_secret`, and Quadlet volume `m05-notes` at `/var/lib/webapp/data`.

### Task 16 (10 pts) - Prove persistence across restart
POST `m05-persist` to `/entries` on port 18502, restart `m05-web.service`, and confirm the note is still listed.

### Task 17 (20 pts) - Quadlet pod
Create `m05-pod.pod` (PodName `m05-pod`, `PublishPort=18503:8080`) with `m05-pod-redis` (redis:7-alpine) and `m05-pod-web` (`auth-reg.lab.local:5444/m05/web:1.0`, `REDIS_HOST=127.0.0.1`, `APP_ENV=production`) starting at boot.

### Task 18 (15 pts) - Compose (the only compose task)
In `m05/compose/compose.yaml` run `m05-cpg` (`quay.io/sclorg/postgresql-16-c10s`, named volume) and `m05-capi` (`localhost/m05-prebuilt-api:1.0`, host port `18504:3000`) on a custom network.

### Task 19 (10 pts) - Export the pod
Export pod `m05-pod` with `podman kube generate` to `m05/pod.yaml`.

### Task 20 (10 pts) - Firewall and linger
Permanently open `18501/tcp`, `18502/tcp`, `18503/tcp`, `18504/tcp`; enable lingering.

### Task 21 (10 pts) - Troubleshoot: exit 126
`m05-ts-126` exits with 126. Fix and keep it running (rebuild is allowed in `m05/ts126`).

### Task 22 (15 pts) - Troubleshoot: isolated network
`m05-ts-api` (port 18507) cannot resolve its database `m05-ts-db`. Fix it.

### Task 23 (10 pts) - Troubleshoot: Quadlet will not survive reboot
`m05-ts-persist.container` (port 18508) is active but would not start after a reboot. Fix the unit.

### Task 24 (10 pts) - Troubleshoot: unhealthy
`m05-ts-hc` (port 18509) is unhealthy though nginx answers. Fix the probe.

### Task 25 (10 pts) - Inventory report
Write `m05/inventory.env`: `POD_INFRA=<InfraContainerID of pod m05-audit-pod>`, `NET_SUBNET=<subnet of network m05-audit-net>`, `SECRET_ID=<ID of secret m05-audit-sec>`.
