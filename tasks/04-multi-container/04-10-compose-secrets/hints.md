## Level 1 — Nudge
Map `source: compose_api_tok` -> `target: api_token` inside the service's `secrets:` array so `/run/secrets/api_token` matches `api-express`'s default path!

## Level 2 — Approach
Create `compose_api_tok` via `printf 'ComposeSec_5520' | podman secret create compose_api_tok -`, write `compose.yaml` with `external: true`, and run `podman compose up -d`.

## Level 3 — Key Commands
```bash
printf 'ComposeSec_5520' | podman secret create compose_api_tok -
cat > ~/workspace/04-10/compose.yaml <<'EOF'
services:
  api:
    image: localhost/api-0410:1.0
    container_name: compose-sec-api
    ports:
      - "3410:3000"
    environment:
      AUTH_REQUIRED: "true"
    secrets:
      - source: compose_api_tok
        target: api_token
secrets:
  compose_api_tok:
    external: true
EOF
cd ~/workspace/04-10 && podman compose up -d
```
