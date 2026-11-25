# EX188 Exam Documentation Reading Guide (Finding Answers Fast Offline)

On the live Red Hat EX188 exam, **you have no internet access, no GUI browser, and no AI assistant** — but you DO have comprehensive offline documentation built right into RHEL 10 (`man` pages, `--help` flags, and `/usr/share/doc`). Knowing *exact* man page names saves 20+ minutes on exam day!

---

## 1. Fast `man` & `less` Navigation Shortcuts

| Keystroke / Command | Action |
| :--- | :--- |
| `man -k quadlet` or `apropos podman` | Search man page short descriptions by keyword |
| `/PublishPort` *(inside `man`)* | Search forward for `PublishPort` (case-insensitive if `-i` typed first) |
| `?EXAMPLES` after pressing `G` | Jump to bottom of man page (`G`), then jump straight to the **`EXAMPLES`** section! |
| `n` / `N` | Jump to next / previous search match |
| `podman run --help \| grep -i secret` | Filter long `--help` flag summaries instantly |

> **Exam Gold Tip**: Almost every Podman and SELinux man page on RHEL 10 has copy-pasteable **`EXAMPLES`** at the bottom! Press **`G`** then **`?EXAM`** as soon as you open a man page!

---

## 2. Exact Man Pages to Memorize for EX188

### Containerfiles & Builds
- **`man containerfile`** *(or `man Containerfile`)* — Complete syntax for `FROM`, `ARG` scope, `ENV`, `COPY --chown --chmod`, `ADD`, `RUN --mount=type=secret`, `VOLUME`, `USER`, `WORKDIR`, `EXPOSE`, `HEALTHCHECK`, `ENTRYPOINT`, and `CMD`.
- **`man containers-ignore`** *(or `man .containerignore`)* — Pattern syntax for `.containerignore`.
- **`man podman-build`** — `--secret`, `--build-arg`, `--format docker` (for `HEALTHCHECK`!), `--target`, `--layers`.

### Registries, Transports & Image Operations
- **`man containers-registries.conf`** — Full TOML v2 examples for `unqualified-search-registries`, `short-name-mode`, `[[registry]]`, `insecure = true`, `blocked = true`, and `[[registry.mirror]]`!
- **`man containers-certs.d`** — Exact directory naming rules for `/etc/containers/certs.d/<host:port>/ca.crt`!
- **`man containers-auth.json`** — Credential file structure and lookup order (`$XDG_RUNTIME_DIR/containers/auth.json` vs `~/.config/containers/auth.json`).
- **`man containers-transports`** — Syntax for `docker://`, `oci-archive:`, `docker-archive:`, and `dir:`.
- **`man podman-save`**, **`man podman-load`**, **`man podman-export`**, **`man podman-import`**, **`man podman-commit`** — Backup & layer flattening flags (`-m`, `--format`, `--change`).

### Running Containers, Secrets & Inspection
- **`man podman-run`** — `--userns=keep-id:uid=...,gid=...`, `-v :z` vs `:Z` vs `:ro`, `--secret`, `--health-cmd`, `--read-only`, `--cap-drop`, `--memory`.
- **`man podman-unshare`** — Shifting host bind-mount UIDs inside the rootless user namespace.
- **`man podman-secret-create`** — Creating secrets from files or stdin (`-`).
- **`man podman-events`**, **`man podman-logs`**, **`man podman-top`**, **`man podman-inspect`** — Monitoring and Go-template examples.

### Quadlet, Pods & Kubernetes YAML (High-Value Exam Pages!)
- **`man podman-systemd.unit`** — **THE #1 MOST IMPORTANT MAN PAGE ON EX188!** Documents every single key for `.container`, `.pod`, `.kube`, `.volume`, and `.network` Quadlet files (`Image=`, `PublishPort=`, `Volume=`, `Secret=`, `Environment=`, `EnvironmentFile=`, `UserNS=`, `Network=`, `Pod=`, `Yaml=`, `ConfigMap=`, `AutoUpdate=`, `PodmanArgs=`), with complete working examples!
- **`man podman-kube-play`** — Playing `Pod`, `Deployment`, `PersistentVolumeClaim`, `ConfigMap`, and `Secret` YAML manifests.
- **`man podman-kube-generate`** — Generating Kubernetes YAML (`-s` service flag, `-f` file output) from existing Podman containers/pods!
- **`man podman-auto-update`** — `AutoUpdate=registry` requirements and `--dry-run`.

### SELinux, Firewall & systemd
- **`man semanage-fcontext`** — Always jump to `EXAMPLES` at the bottom for `semanage fcontext -a -t ... '/path(/.*)?'` + `restorecon -Rv`!
- **`man firewall-cmd`** — `--permanent`, `--add-port=PORT/tcp`, `--reload`.
- **`man loginctl`** — `enable-linger` and `show-user`.

---

## 3. Debugging Quadlets Offline When `systemctl` Shows Nothing

If `systemctl --user start myapp.service` says `Unit myapp.service not found`:
```bash
# For rootless (~/.config/containers/systemd/):
/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun

# For rootful (/etc/containers/systemd/):
sudo /usr/lib/systemd/system-generators/podman-system-generator --dryrun
```
This prints the generated `.service` content to stdout AND prints line-by-line error diagnostics for any misspelled section (`[Containers]`) or invalid key (`Ports=` instead of `PublishPort=`)!

---

## 4. Helpful Files Under `/usr/share/doc` & `/usr/share/containers`
- `/usr/share/containers/containers.conf` — Heavily commented reference showing every supported `containers.conf` setting.
- `/etc/containers/registries.conf` — Built-in commented template showing `[[registry]]` and `[[registry.mirror]]` syntax right in the file!
- `/usr/share/doc/podman/` — Additional release notes and example configurations installed with the `podman` RPM.
