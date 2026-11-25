## Solution
```bash
cat > /home/student/workspace/04-20/catalog.json <<'EOF'
[
  {"sku": "R1", "name": "One", "stock": 1},
  {"sku": "R2", "name": "Two", "stock": 2},
  {"sku": "R3", "name": "Three", "stock": 3}
]
EOF
chmod 0644 /home/student/workspace/04-20/catalog.json

podman rm -f rotatable-api
podman secret rm api_rot_secret
printf 'RotatedToken_2026' | podman secret create api_rot_secret -

podman run -d --name rotatable-api -p 3420:3000 \
  -e AUTH_REQUIRED=true \
  -v /home/student/workspace/04-20/catalog.json:/etc/api-express/catalog.json:ro,Z \
  --secret api_rot_secret,target=/run/secrets/api_token,uid=1001,mode=0400 \
  localhost/api-0420:1.0
```

## Explanation
Even if `podman secret create --replace` replaces a secret in Podman's secret store, an already-running container keeps its existing copied secret file in `/run/secrets/` until the container is recreated!

## Common Mistakes
- Replacing a secret with `--replace` without recreating the container, leaving the old secret active inside the running container!
