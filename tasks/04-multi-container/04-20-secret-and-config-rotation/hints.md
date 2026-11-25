## Level 1 — Nudge
Update `catalog.json` (`0644`), `podman rm -f rotatable-api`, `podman secret rm api_rot_secret` (or `podman secret create --replace`), and start `rotatable-api` again!

## Level 2 — Approach
Podman v5 supports `printf 'RotatedToken_2026' | podman secret create --replace api_rot_secret -` (or `rm` + `create` after removing the container), then re-launch `rotatable-api` so the new secret snapshot is mounted.

## Level 3 — Key Commands
```bash
printf '[{"sku":"R1","name":"One","stock":1},{"sku":"R2","name":"Two","stock":2},{"sku":"R3","name":"Three","stock":3}]\n' > ~/workspace/04-20/catalog.json
chmod 0644 ~/workspace/04-20/catalog.json
podman rm -f rotatable-api
podman secret rm api_rot_secret
printf 'RotatedToken_2026' | podman secret create api_rot_secret -
podman run -d --name rotatable-api -p 3420:3000 -e AUTH_REQUIRED=true \
  -v ~/workspace/04-20/catalog.json:/etc/api-express/catalog.json:ro,Z \
  --secret api_rot_secret,target=/run/secrets/api_token,uid=1001,mode=0400 \
  localhost/api-0420:1.0
```
