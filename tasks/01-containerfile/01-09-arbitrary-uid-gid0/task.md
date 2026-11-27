# Task 01-09: Supporting Arbitrary Non-Root UIDs with Group 0 Permissions

## Objective
Enterprise container platforms such as Red Hat OpenShift execute containers under an arbitrary non-root UID while assigning primary GID `0` (`root` group). Using the pre-staged `webapp-flask` source files in `/home/student/workspace/01-09/`, build an image that runs cleanly under any arbitrary UID in group `0` without modifying `app.py` and without using world-writable (`0777`) permissions.

## Specification
As user `student`, create `/home/student/workspace/01-09/Containerfile` and build `localhost/webapp-ocp-ready:1.0`:
1. Base image: `registry.access.redhat.com/ubi10/ubi:latest` with `python3` installed and cache cleaned.
2. Copy `app.py` and `requirements.txt` into `/opt/webapp/` (`WORKDIR /opt/webapp`) and create `/var/lib/webapp/data`.
3. Configure `/opt/webapp` and `/var/lib/webapp/data` so group `0` owns them and group permissions match owner read/write/execute permissions.
4. Set `ENV APP_PORT=8080 APP_ENV=production CHECK_STORAGE=1`, default `USER 1001`, and exec-form `CMD ["python3", "/opt/webapp/app.py"]`.
5. Verification: the image must pass `/healthz` and `POST /entries` when launched with `--user 42420:0`.
