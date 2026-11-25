## Level 1 — Nudge
Run `podman logs billing-api-0503` — the application itself prints a clear `FATAL:` message explaining why it exited with code `1`!

## Level 2 — Approach
`podman logs billing-api-0503` reports `FATAL: AUTH_REQUIRED=true but neither API_TOKEN_FILE nor API_TOKEN provided a secret.` Create `billing_tok_0503`, remove `billing-api-0503`, and recreate it mounting `--secret billing_tok_0503,target=/run/secrets/api_token,uid=1001,mode=0400`.

## Level 3 — Key Commands
```bash
podman logs billing-api-0503
printf 'FixedToken_0503' | podman secret create billing_tok_0503 -
podman rm -f billing-api-0503
podman run -d --name billing-api-0503 -p 3503:3000 \
  -e AUTH_REQUIRED=true \
  --secret billing_tok_0503,target=/run/secrets/api_token,uid=1001,mode=0400 \
  localhost/ts-api-0503:1.0
```
