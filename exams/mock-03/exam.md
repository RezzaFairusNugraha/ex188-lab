# Red Hat EX188 Full Mock Exam 03 - Multi-Registry Mirroring and Pod/Kube Workloads
- **Time Limit**: 150 minutes | **Total**: 300 points | **Pass**: 210 / 300 (70%)
- **User**: `student` (use `sudo` only for host/system configuration)
- **Persistence**: everything must survive a reboot with no manual action. Before `lab exam grade`, run `sudo systemctl reboot`, log in, then run `lab exam check-reboot`.
- **Vendor code**: never modify files under `/home/student/apps/*` (read each README.md).
- **Workspace**: `/home/student/workspace/m03/` (create sub-directories as needed).
- Tasks are chained: later tasks reuse images, registries and files from earlier ones.

---
### Task 01 (10 pts) - Registry trust and insecure HTTP registry
Trust `/opt/ex188-lab/certs/ca.crt` for `secure-reg.lab.local:5443` and `auth-reg.lab.local:5444` under `/etc/containers/certs.d/` (never mark them insecure). Mark `registry.lab.local:5000` as `insecure = true` in `/etc/containers/registries.conf.d/50-m03.conf`. Do not create `~/.config/containers/registries.conf`.

### Task 02 (10 pts) - Persistent registry login
Log in to `auth-reg.lab.local:5444` as `student` / `redhat123` and store the credentials in `/home/student/.config/containers/auth.json`.

### Task 03 (15 pts) - Registry mirror
Create `/etc/containers/registries.conf.d/60-m03-mirror.conf` so pulls of `mirror-hub.corp.local/...` are served by the mirror location `secure-reg.lab.local:5443` (`[[registry.mirror]]`). Then pull `mirror-hub.corp.local/m03/base:1.0`.

### Task 04 (15 pts) - Pin an image by digest
Write the reference `secure-reg.lab.local:5443/m03/base@sha256:<digest>` for tag `1.0` into `m03/digest-ref.txt` and start container `m03-pinned` from that digest reference running `sleep 3600`.

### Task 05 (10 pts) - Multi-tag promotion
Promote `secure-reg.lab.local:5443/m03/base:1.0` to `auth-reg.lab.local:5444/m03/base` with the tags `1.0`, `1` and `latest`.

### Task 06 (10 pts) - Audit tags with curl
Using only `curl` with CA verification and `student:redhat123`, save `/v2/m03/base/tags/list` of `auth-reg.lab.local:5444` to `m03/tags.json`.

### Task 07 (15 pts) - Non-root web image
Package `/home/student/apps/webapp-flask` as `localhost/m03-web:1.0`: `USER 1001`, `WORKDIR /opt/webapp`, `/var/lib/webapp/data` writable by an arbitrary UID in group 0, exec-form `CMD`, a `.containerignore` excluding `*.secret`. Do not modify `app.py`.

### Task 08 (20 pts) - Multi-stage Go image
Build `localhost/m03-metrics:1.0` from `/home/student/apps/metrics-go` in two stages (static binary, `ubi10/ubi-minimal` runtime, `USER 1001`, exec-form ENTRYPOINT). The runtime stage must not contain the Go toolchain.

### Task 09 (10 pts) - Push application images
Push the two images as `auth-reg.lab.local:5444/m03/web:1.0` and `auth-reg.lab.local:5444/m03/metrics:1.0`.

### Task 10 (10 pts) - Bundle images
Archive both local images in ONE docker-archive tarball `m03/bundle.tar` (`podman save -m`).

### Task 11 (10 pts) - Commit a hotfixed container
Container `m03-hotfix` was patched live. Commit it as `localhost/m03-hotfix:1.1` with author `student@lab.local` and `ENV HOTFIX_APPLIED=1.1`.

### Task 12 (20 pts) - Kubernetes YAML with ConfigMap and PVC
Write `m03/stack.yaml` (ConfigMap `m03-cm` with `app.conf` `SITE_TITLE=M03 Kube`, PVC `m03-pvc`, Pod `m03-kpod` with `redis:7-alpine` and `auth-reg.lab.local:5444/m03/web:1.0`, hostPort `18301` to 8080, `APP_ENV=production`, `REDIS_HOST=127.0.0.1`, app.conf mounted at `/etc/webapp/app.conf`, PVC mounted at `/var/lib/webapp/data`). Deploy with `podman kube play`.

### Task 13 (15 pts) - Persist the kube workload with Quadlet .kube
Stop the CLI-deployed pod (`podman kube down`) and manage the same YAML through `~/.config/containers/systemd/m03-kube.kube` so it starts at boot.

### Task 14 (20 pts) - Quadlet pod
Create `m03-app.pod` (PodName `m03-app`, `PublishPort=18302:8080`) with member containers `m03-app-redis` (redis:7-alpine) and `m03-app-web` (`auth-reg.lab.local:5444/m03/web:1.0`, `APP_ENV=production`, `REDIS_HOST=127.0.0.1`). It must come up at boot.

### Task 15 (20 pts) - Quadlet API with secret and volume
Create secret `m03_tok` (`M03Token_77`, no newline). Deploy `localhost/m03-api:1.0` as Quadlet `m03-api.container` on `18303:3000` with `AUTH_REQUIRED=true`, the secret mounted at `/run/secrets/api_token` (uid 1001, mode 0400), and a Quadlet `.volume` `m03-audit` at `/var/lib/api-express/audit`.

### Task 16 (10 pts) - Authenticated audit write
POST an audit event to `http://127.0.0.1:18303/api/v1/audit` using the token so `audit.log` exists on volume `m03-audit`.

### Task 17 (10 pts) - Firewall and linger
Permanently open `18301/tcp`, `18302/tcp`, `18303/tcp` and enable lingering for `student`.

### Task 18 (15 pts) - Capture events
Write `{{.Status}} {{.Name}}` lines for `start` events of container `m03-api` from the last 2 hours to `m03/events.log` (no streaming).

### Task 19 (10 pts) - Inspect report
With `podman inspect --format` write `m03/report.env` containing `API_USER=<Config.User of m03-api>`, `AUDIT_MP=<Mountpoint of volume m03-audit>`, `KPOD_INFRA=<InfraContainerID of pod m03-app>`.

### Task 20 (10 pts) - Troubleshoot: exit 127
Container `m03-ts-127` (`localhost/m03-ts-127:1.0`) exits with 127. Without rebuilding the image, recreate it so it stays running.

### Task 21 (10 pts) - Troubleshoot: SELinux + UID on bind mount
`m03-ts-se` (port 18306) cannot write to `m03/se-data` although the mode is permissive. Fix it without disabling SELinux and without `chmod 777`.

### Task 22 (10 pts) - Troubleshoot: unhealthy container
`m03-ts-hc` (port 18307) is reported unhealthy although nginx answers. Fix the probe so it becomes healthy.

### Task 23 (15 pts) - Troubleshoot: stale objects block deployment
Run `m03/deploy.sh` (do not edit it) to completion. It fails because of stale objects; remove only what conflicts. `m03-ts-keeper` must keep running.
