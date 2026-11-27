# Task 01-08: Containerizing a Python Web Application as a Non-Root User

## Objective
The vendor application `webapp-flask` (including `app.py`, `requirements.txt`, and `README.md`) has been pre-staged in `/home/student/workspace/01-08/`. Review `README.md` and build a container image without modifying `app.py`.

## Specification
As user `student`, create `/home/student/workspace/01-08/Containerfile` and build `localhost/webapp-flask:1.0`:
1. Base image: `registry.access.redhat.com/ubi10/ubi:latest`.
2. Install `python3` and clean package manager cache in the same layer.
3. Set the working directory to `/opt/webapp` and copy `app.py` and `requirements.txt` into `/opt/webapp/`.
4. Create `/var/lib/webapp/data` writable by numeric UID `1001` (`${APP_UID}` if `--seed` is active).
5. Set runtime environment variables `APP_PORT=8080` and `APP_ENV=production`.
6. Document container port `8080/tcp`, run as numeric user `1001` (`${APP_UID}`), and start `python3 /opt/webapp/app.py` in exec form.
