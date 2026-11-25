# Task 01-05: Setting File Ownership and Permissions During COPY (--chown and --chmod)

## Scenario
Copying a large file and running `RUN chown` in a later layer duplicates every byte in a second image layer. Modern `Containerfile` syntax sets ownership and mode directly during `COPY`.

## Requirements
In `/home/student/workspace/01-05/`:
1. Author `Containerfile` starting from `registry.access.redhat.com/ubi10/ubi-minimal:latest`.
2. Without using `RUN chown` or `RUN chmod`:
   - Copy `launcher.sh` to `/opt/app/launcher.sh` owned by `1001:1001` with mode `0755`.
   - Copy `settings.ini` to `/opt/app/settings.ini` owned by `1001:1001` with mode `0640`.
3. Set `USER 1001`, `WORKDIR /opt/app`, and `CMD ["/opt/app/launcher.sh"]`.
4. Build the image as `localhost/chown-demo:1.0`.
