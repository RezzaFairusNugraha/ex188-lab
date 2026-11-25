# Task 04-16: Persistent Kubernetes Workload Managed by a Quadlet .kube Unit with ConfigMap

## Scenario
By itself, `podman kube play` is imperative — after a system reboot, pods launched via CLI `podman kube play` will **not** restart automatically unless wrapped in a **Quadlet `.kube` unit** (`[Kube]` `Yaml=...`, `ConfigMap=...`)!

## Requirements
1. Create `/home/student/workspace/04-16/kube-cm.yaml` defining `ConfigMap` `portal-cfg` (`APP_ENV: production` and `SITE_TITLE: Quadlet Kube Unit`).
2. Create `/home/student/workspace/04-16/kube-pod.yaml` defining `Pod` `qkube-pod` with:
   - Container `redis` (`docker.io/library/redis:7-alpine`)
   - Container `web` (`localhost/webapp-0416:1.0`, `hostPort: 8416` -> `containerPort: 8080`, `REDIS_HOST=127.0.0.1`, loading `APP_ENV` from `portal-cfg` and writing/mounting `SITE_TITLE` via `/etc/webapp/app.conf` from `portal-cfg`).
3. Create Quadlet unit `~/.config/containers/systemd/qkube-app.kube`:
   - `[Kube]` `Yaml=/home/student/workspace/04-16/kube-pod.yaml` and `ConfigMap=/home/student/workspace/04-16/kube-cm.yaml`
   - `[Install]` `WantedBy=default.target`
4. Reload user systemd, start `qkube-app.service`, ensure linger is enabled, and verify `http://127.0.0.1:8416/` returns `"site_title": "Quadlet Kube Unit"`.
