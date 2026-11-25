# Task 01-11: Build-Time ARG vs Persistent Runtime ENV (--build-arg Overrides)

## Scenario
Build-only parameters (such as an internal artifact repository URL or build stamp) should **not** persist in runtime container `env` output, whereas application version and release channel **should** persist as runtime `ENV` variables.

## Requirements
1. Author `/home/student/workspace/01-11/Containerfile` on `registry.access.redhat.com/ubi10/ubi-minimal:latest`:
   - Declare `ARG BUILD_CHANNEL=dev` and `ARG APP_RELEASE=1.0.0`.
   - Write `${BUILD_CHANNEL}` into `/etc/build-channel` during `RUN`, **without** exporting `BUILD_CHANNEL` as an `ENV` variable.
   - Export `ENV APP_RELEASE=${APP_RELEASE}` and `ENV LOG_FORMAT=json` so both persist at runtime.
   - Set `USER 1001`.
2. Build two images from this single `Containerfile`:
   - `localhost/release-demo:default` (using default `ARG` values).
   - `localhost/release-demo:prod` passing `--build-arg BUILD_CHANNEL=production --build-arg APP_RELEASE=2.4.0` (`${PROD_REL}` if `--seed` is active).
