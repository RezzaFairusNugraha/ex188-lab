## Level 1 — Nudge
Mount the single file `prod-config.js` directly onto `/usr/share/nginx/html/config.js:ro,Z` (with `chmod 0644` so UID `101` can read it!).

## Level 2 — Approach
Write `~/workspace/04-07/prod-config.js`, run `chmod 0644`, and start `portal-configured` mounting that file onto `/usr/share/nginx/html/config.js:ro,Z`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/04-07/prod-config.js <<'EOF'
window.PORTAL_CONFIG = {
  environment: "production",
  region: "eu-west-2",
  apiEndpoint: "https://api.acme.example/v1",
  banner: "Zero-Rebuild Production Override"
};
EOF
chmod 0644 ~/workspace/04-07/prod-config.js
podman run -d --name portal-configured -p 8407:8080 \
  -v ~/workspace/04-07/prod-config.js:/usr/share/nginx/html/config.js:ro,Z \
  localhost/static-portal:1.0
```
