## Solution
```bash
printf 'ComposeSec_5520' | podman secret create compose_api_tok -

cat > /home/student/workspace/04-10/compose.yaml <<'EOF'
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

cd /home/student/workspace/04-10 && podman compose up -d
```

## Explanation
Long-form `secrets:` syntax (`source:` + `target:`) lets you mount Podman secret `compose_api_tok` at `/run/secrets/api_token` instead of `/run/secrets/compose_api_tok`.

## Common Mistakes
- Using short-form `secrets: [compose_api_tok]`, which mounts `/run/secrets/compose_api_tok` instead of `/run/secrets/api_token` unless `API_TOKEN_FILE` is also overridden!
