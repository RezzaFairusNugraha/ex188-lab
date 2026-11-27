# Task 01-05: Setting File Ownership and Permissions During Image Copy

## Objective
As user `student`, package the pre-staged application files in `/home/student/workspace/01-05/` into a non-root container image without creating extra `RUN chown` or `RUN chmod` layers.

## Specification
Create `/home/student/workspace/01-05/Containerfile` and build `localhost/chown-demo:1.0` meeting all of the following criteria:
1. Base image: `registry.access.redhat.com/ubi10/ubi-minimal:latest`.
2. Working directory: `/opt/app`.
3. Copy `launcher.sh` to `/opt/app/launcher.sh` owned by UID:GID `1001:1001` with permissions `0755` — **without** using `RUN chown` or `RUN chmod`.
4. Copy `settings.ini` to `/opt/app/settings.ini` owned by UID:GID `1001:1001` with permissions `0640` — **without** using `RUN chown` or `RUN chmod`.
5. Configure the container to execute as numeric user `1001` with default exec-form command `["/opt/app/launcher.sh"]`.
