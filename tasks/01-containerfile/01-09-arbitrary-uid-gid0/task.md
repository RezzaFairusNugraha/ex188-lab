# Task 01-09: [Extra-Credit Style] Arbitrary Non-Root UID Support with Group 0 Permissions

## Scenario
*(Extra-credit style hardening task)* Enterprise platforms such as Red Hat OpenShift launch containers with an **arbitrary random UID** (for example `1000680000`) while always assigning primary GID `0` (`root` group, with zero root privileges). Images that only grant write permissions to UID `1001` crash with `Permission denied` when launched under a random UID!

## Requirements
1. Copy `/home/student/apps/webapp-flask/` into `/home/student/workspace/01-09/` and author `/home/student/workspace/01-09/Containerfile` on `registry.access.redhat.com/ubi10/ubi:latest`.
2. Configure `/opt/webapp` and `/var/lib/webapp/data` so group `0` (`root` group) owns them (`chgrp -R 0`) and group permissions equal owner permissions (`chmod -R g=u`).
3. Set `ENV APP_PORT=8080 APP_ENV=production CHECK_STORAGE=1`, `USER 1001`, and `CMD ["python3", "/opt/webapp/app.py"]`.
4. Build `localhost/webapp-ocp-ready:1.0`. Grading will start it with `--user 42420:0` and test both `/healthz` and `POST /entries`!
