## Solution
```bash
podman logs billing-api-0503
printf 'FixedToken_0503' | podman secret create billing_tok_0503 -
podman rm -f billing-api-0503
podman run -d --name billing-api-0503 -p 3503:3000 \
  -e AUTH_REQUIRED=true \
  --secret billing_tok_0503,target=/run/secrets/api_token,uid=1001,mode=0400 \
  localhost/ts-api-0503:1.0
```

## Explanation
Exit code `1` indicates the container runtime started the binary normally, and the **application itself** aborted due to a configuration or dependency error — so `podman logs <ctr>` is always the first command for exit code `1`!

## Common Mistakes
- Disabling `AUTH_REQUIRED=true` to bypass the check instead of supplying the required secret.
