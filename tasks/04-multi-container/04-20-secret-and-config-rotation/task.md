# Task 04-20: Rotating a Podman Secret and Mounted Config Without Image Rebuilds

## Scenario
Running container `rotatable-api` (`localhost/api-0420:1.0` on `-p 3420:3000`) currently uses expired Podman secret `api_rot_secret` (`OldExpiredToken`) and mounted `/home/student/workspace/04-20/catalog.json` (containing 1 item). Note that Podman secrets are immutable once created and cannot be deleted while an existing container references them!

## Requirements
1. Without rebuilding `localhost/api-0420:1.0`:
   - Update `/home/student/workspace/04-20/catalog.json` so it contains **3** JSON items (`sku` `R1`, `R2`, `R3`).
   - Stop and remove `rotatable-api`, replace Podman secret `api_rot_secret` with the new token `RotatedToken_2026` (no newline), and re-create `rotatable-api` with the exact same port (`-p 3420:3000`), `-e AUTH_REQUIRED=true`, read-only catalog mount (`/etc/api-express/catalog.json:ro,Z`), and `--secret api_rot_secret,target=/run/secrets/api_token,uid=1001,mode=0400`.
2. Verify `GET /api/v1/info` shows `"catalog_count": 3` and `POST /api/v1/audit` accepts `X-API-Token: RotatedToken_2026` (`201`) while rejecting `OldExpiredToken` (`401`).
