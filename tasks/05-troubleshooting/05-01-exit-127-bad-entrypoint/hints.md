## Level 1 — Nudge
Inspect `broken-web-0501`'s `.State.ExitCode` (or `.State.Error`) and `.Config.Entrypoint` before removing it, then override `--entrypoint python3` at `podman run`!

## Level 2 — Approach
1. Check `podman inspect --format '{{.State.ExitCode}} | {{.Config.Entrypoint}}' broken-web-0501` -> write `127` to `initial-exit.txt`.
2. Remove `broken-web-0501` and run `podman run -d --name broken-web-0501 -p 8501:8080 -e APP_ENV=production --entrypoint python3 localhost/ts-web-0501:1.0 /opt/webapp/app.py`.

## Level 3 — Key Commands
```bash
echo '127' > ~/workspace/05-01/initial-exit.txt
podman rm -f broken-web-0501
podman run -d --name broken-web-0501 -p 8501:8080 -e APP_ENV=production \
  --entrypoint python3 localhost/ts-web-0501:1.0 /opt/webapp/app.py
```
