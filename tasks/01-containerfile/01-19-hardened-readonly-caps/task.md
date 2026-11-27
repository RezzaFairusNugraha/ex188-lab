# Task 01-19: Running an Application with a Read-Only Root Filesystem and Dropped Capabilities

## Objective
The `webapp-flask` source files have been pre-staged in `/home/student/workspace/01-19/`. Build the image and run it under strict runtime security confinement.

## Specification
As user `student`:
1. Build `localhost/webapp-hardened:1.0` from `/home/student/workspace/01-19/` on `registry.access.redhat.com/ubi10/ubi:latest` running as numeric `USER 1001` on port `8080`.
2. Start detached container `hardened-web` publishing host port `8099` to container port `8080` with `APP_ENV=production` and all of the following security settings:
   - Read-only container root filesystem.
   - Temporary in-memory filesystem at `/tmp` (`rw,noexec,nosuid,size=64m`).
   - All Linux capabilities dropped.
   - `no-new-privileges` security option enabled.
3. Confirm `http://127.0.0.1:8099/healthz` returns `200 OK`.
