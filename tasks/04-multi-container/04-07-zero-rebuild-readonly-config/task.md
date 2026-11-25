# Task 04-07: Externalized Read-Only Config Override Without Rebuilding the Image

## Scenario
Read `/home/student/apps/static-portal/README.md`. Pre-built image `localhost/static-portal:1.0` bakes in default `config.js` (`banner: "Default Vendor Configuration"`). Without rebuilding or modifying the image, override `config.js` at runtime!

## Requirements
1. Do **not** rebuild `localhost/static-portal:1.0`.
2. Create `/home/student/workspace/04-07/prod-config.js` (`chmod 0644`) setting:
   ```javascript
   window.PORTAL_CONFIG = {
     environment: "production",
     region: "eu-west-2",
     apiEndpoint: "https://api.acme.example/v1",
     banner: "Zero-Rebuild Production Override"
   };
   ```
3. Run detached container `portal-configured` on `-p 8407:8080` from `localhost/static-portal:1.0`, mounting `/home/student/workspace/04-07/prod-config.js` **read-only** (`:ro,Z`) onto `/usr/share/nginx/html/config.js`.
