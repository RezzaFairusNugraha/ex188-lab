# Task 01-17: Combining Read-Only Config Bind Mounts and Writable Named Volumes

## Objective
The `api-express` application files (`server.js`, `package.json`, `config/`, and `README.md`) have been pre-staged in `/home/student/workspace/01-17/build/`. Package the service and deploy it with a read-only host catalog file and a persistent named audit volume.

## Specification
As user `student`:
1. Create `/home/student/workspace/01-17/build/Containerfile` on `registry.access.redhat.com/ubi10/ubi:latest` (`nodejs` installed, `WORKDIR /opt/api-express`, `/var/lib/api-express/audit` writable by UID `1001`, `USER 1001`, exec-form `CMD ["node", "server.js"]`) and build `localhost/api-express:1.0`.
2. Create `/home/student/workspace/01-17/custom-catalog.json` (world-readable `0644`) containing a 2-element JSON array:
   `[{"sku":"A1","name":"Item1","stock":5},{"sku":"B2","name":"Item2","stock":9}]`
3. Create a Podman named volume `api-audit-vol`.
4. Start detached container `inventory-api` from `localhost/api-express:1.0` publishing host port `3017` to container port `3000`:
   - Mount `/home/student/workspace/01-17/custom-catalog.json` at `/etc/api-express/catalog.json` **read-only** with a shared SELinux label.
   - Mount `api-audit-vol` read-write at `/var/lib/api-express/audit`.
5. Send an HTTP `POST` request to `http://127.0.0.1:3017/api/v1/audit` and verify `audit.log` is created on `api-audit-vol`.
