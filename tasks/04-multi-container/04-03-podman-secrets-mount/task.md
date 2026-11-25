# Task 04-03: Managing Podman Secrets Mounted as Files (/run/secrets) Without Env Leakage

## Scenario
Secrets passed via `-e` appear in `podman inspect` (`Config.Env`)! Mounting a Podman secret as a file (`type=mount`, default at `/run/secrets/<name>`) keeps the credential out of `Config.Env`.

## Requirements
1. Create a Podman secret named `nw_token` from `/home/student/workspace/04-03/token.src` (`TokenMount_4491`).
2. Start detached `api-express` container `sec-mount-api` (`localhost/api-0403:1.0`, pre-built by setup) on `-p 3403:3000` with `-e AUTH_REQUIRED=true` and `--secret nw_token,type=mount,target=/run/secrets/api_token,mode=0400,uid=1001`.
3. Verify `nw_token` does **not** appear in `podman inspect --format '{{.Config.Env}}' sec-mount-api`, while `POST /api/v1/audit` with `X-API-Token: TokenMount_4491` returns `201`.
