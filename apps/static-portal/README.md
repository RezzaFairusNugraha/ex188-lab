# Static Operations Portal (`static-portal`)

> **IMPORTANT — VENDOR APPLICATION NOTICE**
> Do **not** alter `public/index.html` or `public/style.css`. Customize runtime settings solely by mounting `config.js` or server configuration files (`nginx.conf` / `httpd-container.conf`) as documented below.

## 1. Overview
`static-portal` is a zero-build static web dashboard compatible with either `quay.io/nginx/nginx-unprivileged:1.26-alpine` or `ubi10/ubi` with `httpd` / `nginx` packages installed.

## 2. Deployment Paths & Ports
- **Nginx Unprivileged (`quay.io/nginx/nginx-unprivileged:1.26-alpine`)**:
  - DocumentRoot: `/usr/share/nginx/html`
  - Server configuration: `/etc/nginx/conf.d/default.conf` (template provided at `conf/nginx.conf`)
  - Default container port: `8080/tcp` (runs as UID `101`)
- **Apache HTTPD on UBI10 (`registry.access.redhat.com/ubi10/ubi`)**:
  - DocumentRoot: `/var/www/html`
  - Custom unprivileged listener config: `/etc/httpd/conf.d/container.conf` (template at `conf/httpd-container.conf`, listens on `8080/tcp`)
  - Foreground command: `["/usr/sbin/httpd", "-D", "FOREGROUND"]`

## 3. Externalized Runtime Configuration (No Rebuild Required)
- Mount a custom `config.js` read-only (`:ro,Z` or `:ro,z` or Kubernetes `ConfigMap`) at `<DocumentRoot>/config.js` to override `window.PORTAL_CONFIG` (`environment`, `region`, `apiEndpoint`, `banner`).

## 4. Health Endpoint
- `conf/nginx.conf` and `conf/httpd-container.conf` serve `GET /healthz` returning `200 OK` (`OK`) and `GET /` returning the HTML dashboard.
