# Task 01-23: Packaging Vendor Service api-express from Documentation

## Objective
The pre-written Node.js service `api-express` (including `README.md`, `package.json`, `server.js`, and `config/`) has been pre-staged in `/home/student/workspace/01-23/`. Read `README.md` to determine runtime requirements and containerize the service **without modifying `server.js` or `package.json`**.

## Specification
As user `student`:
1. Author `/home/student/workspace/01-23/Containerfile` on `registry.access.redhat.com/ubi10/ubi:latest` following `README.md` (`nodejs`, `WORKDIR /opt/api-express`, writable audit directory, numeric `USER 1001`, port `3000`, exec-form startup command) and build `localhost/northwind-api:1.2` (`localhost/northwind-api:${IMG_TAG}` if `--seed` is active).
2. Start detached container `northwind-prod` publishing host port `3023` (`${HOST_PORT}` if `--seed` is active) to container port `3000` with token authentication enabled and token `nw-prod-9912`.
3. Verify `GET http://127.0.0.1:3023/api/v1/items` returns `200` and `POST http://127.0.0.1:3023/api/v1/audit` requires `X-API-Token: nw-prod-9912`.
