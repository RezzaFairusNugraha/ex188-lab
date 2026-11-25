# EX188 Hands-On Practice Lab Suite (RHEL 10 + Podman v5)

A repeatable, performance-based practice lab suite and mock-exam simulator for the **Red Hat Certified Specialist in Containers (EX188)** exam (V5K curriculum on **RHEL 10** with **Podman v5**).

- **125 Standalone Repeatable Tasks** across 6 domains (weighted partial-credit grading, 3-level progressive hints, clean reset, and `--seed` anti-memorization randomization).
- **5 Full 300-Point Chained Mock Exams** (`150-minute` timer, locked hints/solutions, 70% = `210/300` pass threshold, and `lab exam check-reboot` persistence verification).
- **6 Vendor-Style Sample Applications** (`webapp-flask`, `api-express`, `static-portal`, `metrics-go`, `worker-py`, `stack-voting`) whose source code must **never** be modified — candidates read each app's `README.md` to discover required ports, environment variables, config files, secrets, and volumes.
- **Strictly Podman-Native**: Uses **Podman v5** and `Containerfile` exclusively (zero Docker, zero `Dockerfile`, zero Buildah, and zero learner requirement on `skopeo` or `jq`).

> **Security & Dummy Lab Credentials Notice**
> Every credential appearing in this repository (`student:student`, `student:redhat123`, `ci-bot:Ex188Pass!`, and task practice tokens) is a **dummy lab-only value** for isolated local practice VMs. Real TLS keys/certificates, `htpasswd` files, `auth.json` tokens, offline image tarballs, and `~/.lab` progress state are generated dynamically on the VM by `bootstrap.sh` and excluded by `.gitignore`.

---

## 1. Installation & Quick Start

Run on a fresh **RHEL 10**, **AlmaLinux 10**, **Rocky Linux 10**, or **CentOS Stream 10** virtual machine:

```bash
git clone https://github.com/RezzaFairusNugraha/ex188-lab.git
cd ex188-lab
sudo ./bootstrap.sh

# Switch into the primary exam practice account:
sudo -iu student

# Optional: pre-pull and archive all base images for 100% offline practice:
/opt/ex188-lab/prefetch-images.sh
```

What `bootstrap.sh` configures idempotently:
1. Installs `podman`, `podman-compose` (if available), `firewalld`, `vim-enhanced`, `policycoreutils-python-utils`, `httpd-tools`, `openssl`, `curl`, `jq`, and internal grading dependencies.
2. Creates user `student` with rootless `subuid`/`subgid` ranges, sudo access for rootful/firewall/SELinux objectives, and `loginctl enable-linger student`.
3. Starts three local Podman v2 registries simulating multi-registry enterprise environments:
   - `registry.lab.local:5000` — Plain HTTP (insecure) registry
   - `secure-reg.lab.local:5443` — HTTPS TLS registry signed by `/opt/ex188-lab/certs/ca.crt`
   - `auth-reg.lab.local:5444` — HTTPS TLS + `htpasswd` authenticated registry (`student` / `redhat123`, `ci-bot` / `Ex188Pass!`)
4. Stages read-only vendor applications under `/home/student/apps/` and installs `lab` into `/usr/local/bin/lab` and `~/bin/lab`.

---

## 2. Using the `lab` CLI

```bash
lab list                           # List all 125 tasks with ID, domain, difficulty, points, and status
lab list 03-run-containers         # Filter tasks by domain
lab start 01-08                    # Run setup.sh and display the exam-style task prompt
lab start 01-08 --seed             # Randomize ports/names/tags/UIDs to prevent memorizing answers
lab start --random 05              # Pick a random troubleshooting scenario
lab start --weak                   # Pick the task you have failed most often
lab grade 01-08                    # Grade final system state with partial credit (defaults to active task)
lab hint 01-08 1                   # Progressive hints: 1 = nudge, 2 = approach, 3 = key commands
lab solution 01-08                 # Reveal full solution, explanation, and common mistakes (warns first)
lab reset 01-08                    # Tear down task artifacts and restore clean baseline
lab reset --all                    # Clean all user containers, pods, Quadlets, and active exam locks
lab stats                          # View domain completion percentages, pass rates, and weakest tasks

# Full Mock Exam Workflow (150 minutes, 300 points, hints/solutions locked):
lab exam 1                         # Launch Mock Exam 01 (mock-01 .. mock-05)
sudo systemctl reboot              # Reboot VM to test real boot survival!
lab exam check-reboot              # Verify every persistent service/container came back automatically
lab exam grade                     # Grade all tasks (PASS >= 210 / 300 = 70%) and unlock hints
```

---

## 3. Task Bank Breakdown

| Domain | Easy | Medium | Hard | Total Tasks | Domain Points |
| :--- | :---: | :---: | :---: | :---: | :---: |
| `00-warmup-linux` | 4 | 6 | 2 | **12** | 110 |
| `01-containerfile` | 8 | 12 | 5 | **25** | 360 |
| `02-manage-images` | 6 | 10 | 4 | **20** | 290 |
| `03-run-containers` | 8 | 13 | 5 | **26** | 375 |
| `04-multi-container` | 6 | 10 | 4 | **20** | 290 |
| `05-troubleshooting` | 6 | 12 | 4 | **22** | 320 |
| **Total Standalone Bank** | **38** | **63** | **24** | **125** | **1795** |
| **Mock Exams (`mock-01`..`mock-05`)** | — | — | — | **5 Exams (113 chained tasks)** | **1500 (5 × 300)** |

---

## 4. Recommended 3-Week Exam Study Plan

- **Days 1–2 (Linux & SELinux Foundation)**: Complete `00-warmup-linux` (`00-01`..`00-12`). Practice editing YAML and `Containerfile`s in headless `vim` with `:set et ts=2 sw=2` and zero mouse usage.
- **Days 3–6 (Containerfile Mastery)**: Complete `01-containerfile` (`01-01`..`01-25`). Drill multi-stage builds (`01-15`), `COPY --chown --chmod` (`01-05`), build secrets (`01-20`), `--format docker` for `HEALTHCHECK` (`01-21`), and rootless `keep-id` vs `podman unshare` (`01-18`).
- **Days 7–9 (Registries & Image Forensics)**: Complete `02-manage-images` (`02-01`..`02-20`). Memorize `/etc/containers/certs.d/<host:port>/ca.crt`, `~/.config/containers/auth.json` (persistent vs `/run/user` tmpfs!), `[[registry.mirror]]`, and `save/load` vs `export/import` vs `commit`.
- **Days 10–13 (Running Containers & Quadlets)**: Complete `03-run-containers` (`03-01`..`03-26`). Write `.container` Quadlets from memory (`WantedBy=default.target` for rootless + `loginctl enable-linger`, `WantedBy=multi-user.target` in `/etc/containers/systemd/` for rootful) and practice `podman inspect --format` Go templates.
- **Days 14–16 (Multi-Container Stacks)**: Complete `04-multi-container` (`04-01`..`04-20`). Focus heavily on `podman pod`, `podman kube generate`/`play`, and `.pod`/`.kube`/`.network`/`.volume` Quadlets plus Podman Secrets.
- **Days 17–18 (Broken-System Troubleshooting)**: Complete `05-troubleshooting` (`05-01`..`05-22`) under self-imposed 8-minute limits per task. Always run `podman-system-generator --user --dryrun` when a Quadlet unit is missing!
- **Days 19–21 (Full Dress Rehearsals)**: Take `lab exam 1` through `lab exam 5` under strict 150-minute timers, rebooting before `lab exam grade` every single time, and drilling missed topics with `lab start --weak --seed`.

---

## 5. Official EX188 Objective Coverage Matrix (V5K + V4K Delta Notes)

Every official EX188 objective is covered by multiple hands-on tasks:

| Obj ID | Official EX188 Objective / Skill Area | RHEL 10 / Podman v5 (V5K vs V4K) Notes | Count | Covering Task IDs |
| :--- | :--- | :--- | :---: | :--- |
| **0.1** | Linux Warm-Up: Headless Vim, Streams, Pipes, tee & Env Files | Supporting RHEL 10 CLI | **3** | `00-01`, `00-02`, `00-05` |
| **0.2** | Linux Warm-Up: Users, Groups, Numeric UIDs, Setgid/Sticky & sudo | Supporting RHEL 10 CLI | **2** | `00-03`, `00-04` |
| **0.3** | Linux Warm-Up: Rootless systemd --user, Linger & journalctl | Supporting RHEL 10 CLI | **2** | `00-06`, `00-07` |
| **0.4** | Linux Warm-Up: Socket Inspection (ss), curl & Persistent firewalld | Supporting RHEL 10 CLI | **2** | `00-08`, `00-09` |
| **0.5** | Linux Warm-Up: Storage/Memory Audit, SELinux Contexts & Booleans | Supporting RHEL 10 CLI | **3** | `00-10`, `00-11`, `00-12` |
| **1.1** | Specify Base Images (FROM, Tags, Digests, UBI10 Variants, Multi-Stage) | V5K Same as V4K (UBI10 vs UBI9) | **5** | `01-01`, `01-02`, `01-03`, `01-15`, `01-25` |
| **1.2** | Add Content to Images (COPY vs ADD, --chown, --chmod, .containerignore) | V5K Expanded --chmod/--chown emphasis | **5** | `01-04`, `01-05`, `01-06`, `01-15`, `01-23` |
| **1.3** | Configure Runtime Environment (RUN Layer Hygiene, WORKDIR, Non-Root USER, GID 0) | V5K Same core principles | **5** | `01-03`, `01-07`, `01-08`, `01-09`, `01-24` |
| **1.4** | Document Network Ports (EXPOSE Metadata vs Runtime Port Publishing) | V5K Same | **2** | `01-01`, `01-10` |
| **1.5** | Build & Runtime Variables (ARG vs ENV, Scope Across FROM, --build-arg, --env-file) | V5K Same | **4** | `01-11`, `01-12`, `01-23`, `03-05` |
| **1.6** | Startup Commands (CMD vs ENTRYPOINT, Exec vs Shell Form, Runtime Overrides) | V5K Same | **5** | `01-13`, `01-14`, `01-23`, `01-24`, `01-25` |
| **1.7** | Containerfile Volumes & Rootless Storage (VOLUME, Bind/Named, :z/:Z/:ro, keep-id, unshare) | V5K keep-id:uid,gid syntax in Podman v5 | **8** | `00-12`, `01-16`, `01-17`, `01-18`, `03-18`, `03-24`, `04-06`, `05-08` |
| **1.8** | Image & Runtime Security (Non-Root, Build --secret, --read-only, --cap-drop, Low Ports) | V5K pasta rootless networking | **13** | `01-05`, `01-06`, `01-08`, `01-09`, `01-15`, `01-18`, `01-19`, `01-20`, `01-23`, `01-24`, `01-25`, `03-04`, `03-25` |
| **1.9** | Image Lifecycle (build, prune, system df, LABEL, HEALTHCHECK, auto-update) | V5K OCI default vs --format docker HEALTHCHECK | **8** | `01-01`, `01-07`, `01-21`, `01-22`, `01-24`, `01-25`, `03-20`, `05-17` |
| **2.1** | Private Registry Security (certs.d CA, auth.json, registries.conf Search/Insecure/Mirror/Block) | V5K TOML v2 registries.conf.d drop-ins | **9** | `02-02`, `02-03`, `02-04`, `02-05`, `02-06`, `02-07`, `02-20`, `05-10`, `05-11` |
| **2.2** | Interact with Multiple Registries (podman search, manifest inspect, Digest Pulls, Transports) | V5K Podman-native manifest/transports | **10** | `01-02`, `02-01`, `02-02`, `02-06`, `02-08`, `02-09`, `02-10`, `02-19`, `02-20`, `05-12` |
| **2.3** | Tag & Untag Images (Semantic Multi-Tagging, untag vs rmi, Digest Pinning) | V5K Same | **5** | `02-09`, `02-10`, `02-11`, `02-12`, `02-20` |
| **2.4** | Push & Pull Across Registries & Verify via Registry /v2/ API | V5K Same | **7** | `02-03`, `02-04`, `02-05`, `02-09`, `02-11`, `02-13`, `02-20` |
| **2.5** | Back Up & Restore Images/Containers (save/load OCI & Docker Archive vs export/import vs commit) | V5K Multi-image -m & oci-archive | **6** | `02-14`, `02-15`, `02-16`, `02-17`, `02-18`, `02-19` |
| **3.1** | Run Containers Locally (podman run Flags, Env, Memory/CPU Quotas, Networks, Restart Policies) | V5K cgroup v2 + Netavark default | **10** | `01-12`, `01-19`, `03-01`, `03-05`, `03-06`, `03-07`, `03-16`, `03-21`, `03-23`, `05-20` |
| **3.2** | Expose Applications Publicly (Port Publishing, IP Binding, Low-Port sysctl, firewalld) | V5K pasta replaces slirp4netns | **7** | `01-10`, `03-02`, `03-03`, `03-04`, `03-19`, `03-25`, `05-06` |
| **3.3** | Inspect Container Logs (podman logs Filters/Timestamps, journald Driver & journalctl) | V5K journald integration | **2** | `03-08`, `03-09` |
| **3.4** | Monitor & Capture Container Lifecycle Events (podman events Filters & Go Templates) | V5K --stream=false historical queries | **1** | `03-10` |
| **3.5** | Extract Metadata with podman inspect --format Go Templates | V5K Go templates primary (no jq dependency) | **3** | `03-11`, `03-12`, `05-21` |
| **3.6** | Inspect & Connect to Running Containers (ps, top, stats, port, diff, exec -it, attach, cp) | V5K Explicit attach vs exec -it coverage | **5** | `03-13`, `03-14`, `03-15`, `03-23`, `03-26` |
| **3.7** | Persistent systemd Services via Quadlet (.container Rootless & Rootful, Linger) | V5K MAJOR CHANGE: Quadlet replaces deprecated podman generate systemd | **15** | `03-07`, `03-17`, `03-18`, `03-19`, `03-20`, `03-21`, `03-22`, `03-24`, `03-25`, `04-14`, `04-15`, `04-16`, `04-19`, `05-15`, `05-16` |
| **4.1** | Deploy Multi-Container Stacks (Pods, podman kube play/generate, Quadlet .pod/.kube, Compose) | V5K MAJOR CHANGE: .pod/.kube Quadlets & podman compose | **15** | `04-02`, `04-08`, `04-09`, `04-10`, `04-11`, `04-12`, `04-13`, `04-14`, `04-15`, `04-16`, `04-18`, `04-19`, `05-19`, `05-21`, `05-22` |
| **4.2** | Manage Service Dependencies, Healthcheck Ordering & Custom Network DNS/Aliases | V5K aardvark-dns + Quadlet Requires=/After= | **7** | `04-01`, `04-09`, `04-14`, `04-17`, `04-18`, `04-19`, `05-09` |
| **4.3** | Configure Multi-Container Environment Variables (env, env_file, .env Interpolation) | V5K Same | **2** | `04-08`, `04-17` |
| **4.4** | Manage Sensitive Data with Podman Secrets (mount & env Targets, Kube Secret, Quadlet Secret=) | V5K Quadlet Secret= directive | **7** | `04-03`, `04-04`, `04-10`, `04-13`, `04-18`, `04-19`, `04-20` |
| **4.5** | Persist Multi-Container Data (Named Volumes, PVCs, Shared :z Bind Mounts, Container Replacement) | V5K Quadlet .volume & kube play PVCs | **6** | `04-05`, `04-06`, `04-08`, `04-12`, `04-18`, `05-14` |
| **4.6** | Externalize Application Configuration (Read-Only Config Mounts, Kube ConfigMaps, Zero-Rebuild) | V5K Quadlet .kube ConfigMap= | **7** | `04-07`, `04-13`, `04-16`, `04-17`, `04-18`, `04-20`, `05-22` |
| **5.1** | Troubleshoot Startup & Runtime Crashes (Exit Codes 1/126/127/137, OOMKilled, Missing Config) | V5K Same | **5** | `05-01`, `05-02`, `05-03`, `05-18`, `05-20` |
| **5.2** | Troubleshoot Networking, Port Conflicts, DNS Mismatches, Resource Inspection & Kube YAML | V5K Netavark subnet conflicts & kube generate | **7** | `05-04`, `05-05`, `05-06`, `05-09`, `05-19`, `05-21`, `05-22` |
| **5.3** | Troubleshoot Storage, SELinux Denials, Rootless UID Mismatches & Disk Exhaustion | V5K Same | **5** | `05-07`, `05-08`, `05-14`, `05-17`, `05-18` |
| **5.4** | Troubleshoot Registry Pull Failures (certs.d Port Mismatch, Blocked Rules, Auth, Short Names) | V5K short-name-mode=enforcing | **3** | `05-10`, `05-11`, `05-12` |
| **5.5** | Troubleshoot Failing Healthchecks & Broken Quadlet/systemd Persistence (Generator Dry-Run) | V5K podman-system-generator --user --dryrun | **3** | `05-13`, `05-15`, `05-16` |

---

## 6. Reference Guides Included
- [cheatsheet.md](./cheatsheet.md) — Podman v5, Containerfile, Quadlet, Go templates, SELinux, `firewalld`, and configuration file paths.
- [docs-reading-guide.md](./docs-reading-guide.md) — How to locate exact syntax in `man` pages and `/usr/share/doc` in seconds during the offline exam.
