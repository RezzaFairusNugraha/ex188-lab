# EX188 Quick Reference Cheatsheet (RHEL 10 + Podman v5)

## 1. Essential Configuration File Paths

| Purpose | Rootless (`student`) Path | Rootful (`root` / System) Path |
| :--- | :--- | :--- |
| **Quadlet Units** (`.container`, `.pod`, `.kube`, `.volume`, `.network`) | `~/.config/containers/systemd/` | `/etc/containers/systemd/` |
| **Quadlet `[Install]` Boot Target** | `WantedBy=default.target` (+ `linger`) | `WantedBy=multi-user.target` |
| **Registry Configuration** | `~/.config/containers/registries.conf` *(overrides `/etc` completely if present!)* | `/etc/containers/registries.conf` & `/etc/containers/registries.conf.d/*.conf` |
| **Per-Registry TLS CA Certs** | `~/.config/containers/certs.d/<host:port>/ca.crt` | `/etc/containers/certs.d/<host:port>/ca.crt` *(must include `:port`!)* |
| **Persistent Registry Auth** | `~/.config/containers/auth.json` | `/root/.config/containers/auth.json` |
| **Ephemeral Login Auth (Lost on Reboot!)** | `$XDG_RUNTIME_DIR/containers/auth.json` (`/run/user/1000/...`) | `/run/containers/0/auth.json` |
| **Container Engine Defaults** | `~/.config/containers/containers.conf` | `/etc/containers/containers.conf` |
| **Overlay Storage Config & Store** | `~/.config/containers/storage.conf` / `~/.local/share/containers/storage/` | `/etc/containers/storage.conf` / `/var/lib/containers/storage/` |
| **Signature Policy** | `~/.config/containers/policy.json` | `/etc/containers/policy.json` |

---

## 2. Containerfile & `podman build`

```dockerfile
ARG BASE_TAG=latest
FROM registry.access.redhat.com/ubi10/ubi:${BASE_TAG} AS builder
ARG BASE_TAG
RUN dnf install -y python3 \
    && mkdir -p /opt/app /var/lib/app \
    && chown -R 1001:0 /opt/app /var/lib/app \
    && chmod -R g=u /opt/app /var/lib/app \
    && dnf clean all
WORKDIR /opt/app
COPY --chown=1001:0 --chmod=0755 app.py /opt/app/app.py
ADD local-assets.tar.gz /opt/app/static/
ENV APP_PORT=8080
EXPOSE 8080
VOLUME ["/var/lib/app"]
USER 1001
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["python3", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/healthz')"]
ENTRYPOINT ["python3", "/opt/app/app.py"]
CMD ["--workers", "2"]
```

```bash
# Standard build (reads Containerfile automatically):
podman build -t localhost/myapp:1.0 .

# Preserve HEALTHCHECK metadata (OCI default strips HEALTHCHECK!):
podman build --format docker -t localhost/myapp:1.0 .

# Mount a build-time secret without leaking into layers or history:
# In Containerfile: RUN --mount=type=secret,id=mysec cat /run/secrets/mysec ...
podman build --secret id=mysec,src=./token.txt -t localhost/myapp:1.0 .
```

---

## 3. Registries, Tags, Transports & Backups

```toml
# /etc/containers/registries.conf.d/50-custom.conf (TOML v2 syntax!)
unqualified-search-registries = ["registry.access.redhat.com", "quay.io"]
short-name-mode = "enforcing"

[[registry]]
location = "registry.lab.local:5000"
insecure = true

[[registry]]
prefix = "upstream.corp.example"
location = "upstream.corp.example"
[[registry.mirror]]
location = "secure-reg.lab.local:5443"

[[registry]]
prefix = "blocked.example.io"
location = "blocked.example.io"
blocked = true
```

```bash
# Re-pushing a GPG-signed Red Hat UBI image to a private registry:
podman push --remove-signatures secure-reg.lab.local:5443/ns/ubi-minimal:1.0

# Persistent login (survives reboot!):
podman login --authfile ~/.config/containers/auth.json -u student -p redhat123 auth-reg.lab.local:5444

# Remote tag listing & manifest inspection without pulling layers:
podman search --list-tags secure-reg.lab.local:5443/ns/app
podman manifest inspect docker://secure-reg.lab.local:5443/ns/app:1.0

# Registry v2 HTTP API via curl:
curl -fsS --cacert /path/ca.crt -u user:pass https://auth-reg.lab.local:5444/v2/_catalog
curl -fsS --cacert /path/ca.crt -u user:pass https://auth-reg.lab.local:5444/v2/ns/app/tags/list

# Backups: save/load (image + layers + metadata) vs export/import (flat container fs, 1 layer, no metadata) vs commit:
podman save --format oci-archive -o app-oci.tar localhost/app:1.0
podman save -m --format docker-archive -o multi.tar localhost/web:1.0 localhost/api:1.0
podman load -i app-oci.tar
podman pull dir:/path/to/unpacked-dir
podman export -o rootfs.tar my-container
podman import --change 'USER 1001' --change 'CMD ["/bin/app"]' rootfs.tar localhost/flat:1.0
podman commit --author "student" --change 'ENV PATCHED=1' my-container localhost/snap:1.1
```

---

## 4. Running, Inspecting & Connecting to Containers

```bash
# Rootless bind mount with UID 1001 mapping + private SELinux label (:Z):
podman run -d --name webapp -p 0.0.0.0:8080:8080 \
  --userns=keep-id:uid=1001,gid=1001 \
  -v /srv/appdata:/var/lib/webapp/data:Z \
  --env-file ./app.env -e APP_ENV=production \
  --memory 256m --memory-swap 256m --cpus 0.5 \
  --read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  --cap-drop=ALL --security-opt=no-new-privileges \
  localhost/webapp:1.0

# Alternative rootless host ownership shift without keep-id:
podman unshare chown -R 1001:1001 /srv/appdata

# Go templates (primary exam inspection method — works without jq!):
podman inspect --format '{{.State.ExitCode}} | OOM={{.State.OOMKilled}}' myctr
podman inspect --format '{{(index .NetworkSettings.Networks "my-net").IPAddress}}' myctr
podman inspect --format '{{index .Config.Labels "com.example.team"}}' myctr
podman inspect --format '{{range .Mounts}}{{.Type}}:{{.Destination}}{{"\n"}}{{end}}' myctr

# Logs, events, processes, attach vs exec, cp:
podman logs -t --tail 20 myctr
podman events --since 30m --stream=false -f container=myctr -f event=start --format '{{.Status}} {{.Name}}'
podman top myctr user huser pid hpid label comm
podman attach myctr          # Detach safely with: Ctrl-P then Ctrl-Q
podman exec -it myctr /bin/sh
podman cp myctr:/etc/app.conf ./app.conf
```

---

## 5. Quadlet (`podman-systemd.unit(5)`) — Reboot Persistence

> **Note**: `podman generate systemd` is **deprecated** in Podman v5. Always use Quadlets! Never run `systemctl enable` on a generated Quadlet unit — `[Install] WantedBy=` enables it automatically on `daemon-reload`!

```ini
# ~/.config/containers/systemd/webapp.container
[Unit]
Description=Persistent Webapp Container
Requires=db.service
After=db.service

[Container]
Image=auth-reg.lab.local:5444/prod/webapp:1.0
ContainerName=webapp
Network=appnet.network
PublishPort=8080:8080
EnvironmentFile=/home/student/webapp.env
Environment=APP_ENV=production
Volume=appdata.volume:/var/lib/webapp/data
Secret=web_sec,type=mount,target=/run/secrets/webapp_secret,uid=1001,mode=0400
UserNS=keep-id:uid=1001,gid=1001
AutoUpdate=registry

[Service]
Restart=always

[Install]
WantedBy=default.target
```

```bash
# Always dry-run the Quadlet generator first to catch typos!
/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun

systemctl --user daemon-reload
systemctl --user start webapp.service
sudo loginctl enable-linger student
```

- **`.pod` unit** (`my-stack.pod`) -> generates **`my-stack-pod.service`**; member `.container` files set `Pod=my-stack.pod`.
- **`.kube` unit** (`my-kube.kube`) -> generates **`my-kube.service`**; sets `Yaml=/abs/path/pod.yaml` and optional `ConfigMap=/abs/path/cm.yaml`.
- **`.network` / `.volume` units** (`foo.network` / `bar.volume`) -> referenced as `Network=foo.network` and `Volume=bar.volume:/dest`.

---

## 6. SELinux, Privileged Low Ports & `firewalld`

```bash
# Firewalld (MUST pass both --permanent AND --reload!):
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports

# Rootless privileged ports (< 1024) persistent across reboot:
echo 'net.ipv4.ip_unprivileged_port_start = 80' | sudo tee /etc/sysctl.d/90-lowports.conf
sudo sysctl --system

# Persistent SELinux file contexts & booleans:
ls -laZ /srv/webroot
ps -efZ | grep container_t
sudo semanage fcontext -a -t container_file_t '/srv/webroot(/.*)?'
sudo restorecon -Rv /srv/webroot
sudo setsebool -P container_manage_cgroup on
```
