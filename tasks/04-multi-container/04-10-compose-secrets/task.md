# Task 04-10: Consuming External Podman Secrets in compose.yaml

## Scenario
Reference a Podman secret (`compose_api_tok`) inside `/home/student/workspace/04-10/compose.yaml` so `api-express` (`localhost/api-0410:1.0`, pre-built) mounts `/run/secrets/api_token` cleanly without embedding credentials in YAML!

## Requirements
1. Create Podman secret `compose_api_tok` containing `ComposeSec_5520` (no trailing newline).
2. Create `/home/student/workspace/04-10/compose.yaml` declaring top-level `secrets:` (`compose_api_tok:` with `external: true`) and service `api` (`container_name: compose-sec-api`, `localhost/api-0410:1.0`) publishing `3410:3000` with `AUTH_REQUIRED=true` and mounting `compose_api_tok` at target `api_token` (`/run/secrets/api_token`).
3. Start the stack with `podman compose up -d` and verify `POST http://127.0.0.1:3410/api/v1/audit` with `X-API-Token: ComposeSec_5520` returns `201`.
