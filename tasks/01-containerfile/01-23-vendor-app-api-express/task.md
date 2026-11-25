# Task 01-23: Packaging Pre-Written Vendor App api-express Strictly from README.md

## Scenario
Just like on the real EX188 exam, you must read the vendor documentation in `/home/student/apps/api-express/README.md` to discover required paths, ports, environment variables, and authentication settings — **without modifying any `.js` or `.json` file** from the vendor directory.

## Requirements
1. Stage the vendor files from `/home/student/apps/api-express/` into `/home/student/workspace/01-23/` without altering `server.js` or `package.json`.
2. Build image `localhost/northwind-api:1.2` (`localhost/northwind-api:${IMG_TAG}` if `--seed` is active) on `registry.access.redhat.com/ubi10/ubi:latest` following every requirement in `README.md` (working directory, non-root UID `1001`, default port `3000`, writable audit directory).
3. Run detached container `northwind-prod` publishing host port `3023` (`${HOST_PORT}` if `--seed` is active) to container port `3000`, with `AUTH_REQUIRED=true` and `API_TOKEN=nw-prod-9912` (or Podman secret at `/run/secrets/api_token`).
4. Verify `GET /api/v1/items` returns `200 OK` and `POST /api/v1/audit` with header `X-API-Token: nw-prod-9912` returns `201`.
