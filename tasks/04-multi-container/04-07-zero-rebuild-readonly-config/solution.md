## Solution
```bash
cat > /home/student/workspace/04-07/prod-config.js <<'EOF'
window.PORTAL_CONFIG = {
  environment: "production",
  region: "eu-west-2",
  apiEndpoint: "https://api.acme.example/v1",
  banner: "Zero-Rebuild Production Override"
};
EOF
chmod 0644 /home/student/workspace/04-07/prod-config.js

podman run -d --name portal-configured -p 8407:8080 \
  -v /home/student/workspace/04-07/prod-config.js:/usr/share/nginx/html/config.js:ro,Z \
  localhost/static-portal:1.0
```

## Explanation
Mounting a single file (`/usr/share/nginx/html/config.js`) overlays ONLY that file while leaving sibling files (`index.html`, `style.css`) from the image intact! Mounting the whole directory would hide `index.html` and `style.css`!

## Common Mistakes
- Mounting an entire directory over `/usr/share/nginx/html`, hiding `index.html` and `style.css` from the image!
