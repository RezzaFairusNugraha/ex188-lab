# Task 01-17: Read-Only Configuration Mounts (:ro), Shared Labels (:z), and Named Volumes

## Scenario
Read `/home/student/apps/api-express/README.md`. You must package `api-express` and run it with a **read-only** host catalog bind mount (`:ro,z`) alongside a **writable** Podman named volume for audit logs.

## Requirements
1. Build `localhost/api-express:1.0` from `/home/student/apps/api-express/` (copied into `/home/student/workspace/01-17/build/`) on `registry.access.redhat.com/ubi10/ubi:latest` with `nodejs`, `WORKDIR /opt/api-express`, `USER 1001`, and `CMD ["node", "/opt/api-express/server.js"]`.
2. Create a custom JSON file `/home/student/workspace/01-17/custom-catalog.json` containing a 2-item JSON array (`[{"sku":"A1","name":"Item1","stock":5},{"sku":"B2","name":"Item2","stock":9}]`).
3. Create a Podman named volume `api-audit-vol`.
4. Run detached container `inventory-api` on `-p 3017:3000` mounting:
   - `/home/student/workspace/01-17/custom-catalog.json` at `/etc/api-express/catalog.json` **read-only** with shared SELinux label (`:ro,z`).
   - Named volume `api-audit-vol` writable at `/var/lib/api-express/audit`.
5. Trigger `POST http://127.0.0.1:3017/api/v1/audit` so at least one audit entry is written to `api-audit-vol`.
