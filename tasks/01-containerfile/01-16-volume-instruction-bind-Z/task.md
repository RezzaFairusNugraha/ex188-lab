# Task 01-16: Persistent Host Bind Mount with SELinux Relabeling

## Objective
The `webapp-flask` source files have been pre-staged in `/home/student/workspace/01-16/`, along with an empty host directory `/home/student/workspace/01-16/host-notes`. Build a stateful web image and persist journal entries onto the host directory with SELinux enforcing.

## Specification
As user `student`:
1. Create `/home/student/workspace/01-16/Containerfile` on `registry.access.redhat.com/ubi10/ubi:latest`:
   - Install `python3`, copy `app.py` and `requirements.txt` into `/opt/webapp/`, prepare `/var/lib/webapp/data`, declare `/var/lib/webapp/data` as a `VOLUME`, set `USER 1001`, and configure exec-form `CMD ["python3", "/opt/webapp/app.py"]`.
   - Build the image as `localhost/webapp-vol:1.0`.
2. Start detached container `notes-writer` publishing host port `8096` to container port `8080` with `APP_ENV=production`:
   - Bind-mount `/home/student/workspace/01-16/host-notes` onto `/var/lib/webapp/data` with a **private** SELinux context label.
   - Configure rootless user namespace UID mapping so container UID `1001` can write to `host-notes` owned by `student`.
3. Submit an HTTP `POST` request to `http://127.0.0.1:8096/entries` with note text `first-persistent-note` and verify `/home/student/workspace/01-16/host-notes/entries.log` contains the entry on the host.
