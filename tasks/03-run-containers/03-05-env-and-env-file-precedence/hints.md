## Level 1 — Nudge
Explicit `-e KEY=VAL` flags on `podman run` always take precedence over values loaded from `--env-file`.

## Level 2 — Approach
Run `podman run -d --name env-precedence -p 8305:8080 --env-file ~/workspace/03-05/base.env -e APP_ENV=production localhost/webapp-envtest:1.0`.

## Level 3 — Key Commands
```bash
podman run -d --name env-precedence -p 8305:8080 \
  --env-file ~/workspace/03-05/base.env \
  -e APP_ENV=production \
  localhost/webapp-envtest:1.0
```
