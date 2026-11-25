# Task 01-08: Packaging webapp-flask with Non-Root Numeric USER and WORKDIR

## Scenario
Read `/home/student/apps/webapp-flask/README.md`. You must containerize `webapp-flask` without modifying its source code, running as a dedicated numeric non-root UID.

## Requirements
1. Copy the vendor application files from `/home/student/apps/webapp-flask/` into `/home/student/workspace/01-08/` and author `/home/student/workspace/01-08/Containerfile` on `registry.access.redhat.com/ubi10/ubi:latest`.
2. Install `python3` (and `python3-pip` if online; note `app.py` also runs cleanly on stdlib WSGI if offline), set `WORKDIR /opt/webapp`, and copy `app.py` (and `requirements.txt`) into `/opt/webapp/`.
3. Create `/var/lib/webapp/data` owned by numeric UID `1001` (`${APP_UID}` if `--seed` is active), set `ENV APP_PORT=8080 APP_ENV=production`, `EXPOSE 8080`, `USER 1001` (`${APP_UID}`), and exec-form `CMD ["python3", "/opt/webapp/app.py"]`.
4. Build the image as `localhost/webapp-flask:1.0`.
