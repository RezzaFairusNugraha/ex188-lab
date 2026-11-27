# Task 03-14: Non-Interactive Command Execution and Bidirectional File Copy (podman exec and cp)

## Objective
Running container `portal-live` (`quay.io/nginx/nginx-unprivileged:1.26-alpine` on `-p 8314:8080`) has an outdated `/usr/share/nginx/html/index.html` and stores a diagnostic report at `/tmp/diag-report.txt`.

## Specification
1. Copy `/tmp/diag-report.txt` **out** of `portal-live` to `/home/student/workspace/03-14/diag-report.txt` using `podman cp`.
2. Copy `/home/student/workspace/03-14/new-index.html` **into** `portal-live` at `/usr/share/nginx/html/index.html`.
3. Execute `nginx -s reload` inside `portal-live` using `podman exec` and verify `http://127.0.0.1:8314/` serves `Updated Live via podman cp`.
