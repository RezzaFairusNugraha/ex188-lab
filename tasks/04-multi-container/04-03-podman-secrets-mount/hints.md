## Level 1 — Nudge
Check `man podman-secret-create` and `man podman-run` (`--secret name,type=mount,target=...,uid=...,mode=...`).

## Level 2 — Approach
Create secret `nw_token` from `~/workspace/04-03/token.src`, then launch `sec-mount-api` with `--secret nw_token,type=mount,target=/run/secrets/api_token,uid=1001,mode=0400`.

## Level 3 — Key Commands
```bash
podman secret create nw_token ~/workspace/04-03/token.src
podman run -d --name sec-mount-api -p 3403:3000 \
  -e AUTH_REQUIRED=true \
  --secret nw_token,type=mount,target=/run/secrets/api_token,uid=1001,mode=0400 \
  localhost/api-0403:1.0
```
