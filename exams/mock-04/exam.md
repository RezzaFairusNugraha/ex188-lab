# Red Hat EX188 Full Mock Exam 04 - Enterprise Three-Tier Stack and Secret Management
- **Time Limit**: 150 minutes | **Total**: 300 points | **Pass**: 210 / 300 (70%)
- **User**: `student` (use `sudo` only for host/system configuration)
- **Persistence**: everything must survive a reboot with no manual action. Before `lab exam grade`, run `sudo systemctl reboot`, log in, then run `lab exam check-reboot`.
- **Vendor code**: never modify files under `/home/student/apps/*` (read each README.md).
- **Workspace**: `/home/student/workspace/m04/` (create sub-directories as needed).
- Tasks are chained: later tasks reuse images, registries and files from earlier ones.

---
### Task 01 (10 pts) - Registry trust and insecure HTTP registry
Trust `/opt/ex188-lab/certs/ca.crt` for `secure-reg.lab.local:5443` and `auth-reg.lab.local:5444` under `/etc/containers/certs.d/`, and mark `registry.lab.local:5000` insecure in `/etc/containers/registries.conf.d/50-m04.conf`.

### Task 02 (10 pts) - Persistent login
Log in to `auth-reg.lab.local:5444` as `ci-bot` / `Ex188Pass!` and persist the credentials in `~/.config/containers/auth.json`.

### Task 03 (10 pts) - List remote tags
Save the output of `podman search --list-tags registry.lab.local:5000/m04-seed/tool` to `m04/tags.txt`.

### Task 04 (10 pts) - Promote between registries
Promote `registry.lab.local:5000/m04-seed/tool:2.0` to `secure-reg.lab.local:5443/m04/tool:2.0` using pull, tag, push.

### Task 05 (20 pts) - Build the voting images
Using `/home/student/apps/stack-voting` (read its README), build `localhost/m04-vote-api:1.0` and `localhost/m04-vote-ui:1.0` with the vendor Containerfiles.

### Task 06 (15 pts) - Build-time secret
In `m04/secret-build/` build `localhost/m04-secret-build:1.0` that stores only the SHA256 of `m04/build.key` in `/etc/bkey.sha256`, using `--secret`/`RUN --mount=type=secret`. The raw key must not appear in `podman history --no-trunc`.

### Task 07 (10 pts) - Push voting images
Push both voting images to `auth-reg.lab.local:5444/m04/vote-api:1.0` and `auth-reg.lab.local:5444/m04/vote-ui:1.0`.

### Task 08 (10 pts) - Create the database secret
Create Podman secret `m04_db_pass` with the exact value `M04DbPass_55` (no trailing newline).

### Task 09 (30 pts) - Compose deployment (the only compose task)
In `m04/compose/compose.yaml` deploy `m04-db` (`quay.io/sclorg/postgresql-16-c10s`, volume at `/var/lib/pgsql/data`, user `voteuser`, database `votesdb`, password `M04DbPass_55`), `m04-cache` (redis:7-alpine), `m04-api` (`auth-reg.lab.local:5444/m04/vote-api:1.0`, `DB_HOST=m04-db`, `CACHE_HOST=m04-cache`, secret `m04_db_pass` mounted at `/run/secrets/db_password`) and `m04-ui` (`auth-reg.lab.local:5444/m04/vote-ui:1.0`, host port `18401`, `API_BASE_URL=http://m04-api:4000`). Only the UI publishes a port.

### Task 10 (10 pts) - Bring compose down but keep data
Stop the compose stack WITHOUT deleting its volumes.

### Task 11 (30 pts) - Quadlet three-tier stack
Redeploy the stack as Quadlets: `m04-q.network`, volumes for the database and ballots, and containers `m04-q-db` (secret as env `POSTGRESQL_PASSWORD`), `m04-q-cache`, `m04-q-api` (secret mounted, `Requires=`/`After=` db and cache) and `m04-q-ui` (host port `18402`). Everything starts at boot.

### Task 12 (10 pts) - Export the API definition
Generate Kubernetes YAML for container `m04-q-api` with `podman kube generate` into `m04/api-export.yaml`.

### Task 13 (10 pts) - Firewall and linger
Permanently open `18401/tcp` and `18402/tcp`; enable lingering for `student`.

### Task 14 (10 pts) - Lifecycle events
Write `{{.Status}} {{.Name}}` of `start` events of `m04-q-ui` (last 2 hours, no streaming) to `m04/ui-events.log`.

### Task 15 (15 pts) - Copy a file out of a running container
Copy `/opt/vote-ui/app.py` out of `m04-q-ui` to `m04/ui-app.py` with `podman cp`.

### Task 16 (15 pts) - Inspect report
With Go templates write `m04/inspect.env`: `UI_USER=<Config.User of m04-q-ui>`, `API_DB_HOST=<value of DB_HOST in the env of m04-q-api>`.

### Task 17 (15 pts) - Troubleshoot: UID mismatch
`m04-ts-uid` (port 18405, image `localhost/m04-ts-web`, USER 1001) cannot write to `m04/journal` although `:Z` is set. Fix without `chmod 777` and without running as root.

### Task 18 (15 pts) - Troubleshoot: DNS/network
`m04-ts-app` (port 18406) cannot reach `m04-ts-db`. Fix networking and the DB hostname.

### Task 19 (15 pts) - Troubleshoot: Quadlet not found
`m04-ts-lost.container` exists but `m04-ts-lost.service` does not. Make it run on port 18407 and start at boot. Use the generator dry-run to find the errors.

### Task 20 (15 pts) - Troubleshoot: OOM kill
`m04-ts-oom` keeps dying with exit 137. Recreate it with a 128m memory limit (memory-swap 128m) without changing the image.

### Task 21 (15 pts) - Troubleshoot: wrong tag and short name
`m04/deploy.sh` fails (wrong tag, unqualified name). Fix the script so container `m04-ts-deploy` runs from the correct fully qualified image.
