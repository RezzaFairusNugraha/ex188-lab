# Task 05-03: Diagnosing Crash-Loop Exit Code 1 via podman logs and Vendor README

## Scenario
Container `billing-api-0503` exited immediately with code `1`. Inspect `podman logs billing-api-0503`, `podman inspect billing-api-0503`, and `/home/student/apps/api-express/README.md` to see what startup requirement was violated!

## Requirements
1. Do **not** modify `api-express` code or rebuild `localhost/ts-api-0503:1.0`, and keep `AUTH_REQUIRED=true` enabled!
2. Create Podman secret `billing_tok_0503` (`FixedToken_0503`) and recreate running container `billing-api-0503` on `-p 3503:3000` with `AUTH_REQUIRED=true` and the secret mounted where `api-express` expects it.
3. Verify `http://127.0.0.1:3503/healthz` returns `200 OK`.
