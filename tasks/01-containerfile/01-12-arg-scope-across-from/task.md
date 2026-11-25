# Task 01-12: ARG Scope Before and After FROM Plus Runtime --env-file Overrides

## Scenario
An `ARG` declared **before** `FROM` can parameterize the `FROM` image line itself, but goes out of scope immediately after `FROM` unless re-declared inside the build stage!

## Requirements
1. Create `/home/student/workspace/01-12/Containerfile`:
   - Declare `ARG UBI_VARIANT=ubi-minimal` **before** `FROM`.
   - Use `FROM registry.access.redhat.com/ubi10/${UBI_VARIANT}:latest`.
   - Re-declare `ARG UBI_VARIANT` **after** `FROM` so `/etc/selected-variant` records its value during `RUN`.
   - Set default `ENV SERVICE_TIER=standard SERVICE_PORT=8080`, `USER 1001`, and `CMD ["sh", "-c", "sleep 3600"]`.
2. Build `localhost/scoped-ubi:1.0` with `--build-arg UBI_VARIANT=ubi-minimal`.
3. Create `/home/student/workspace/01-12/runtime.env` setting `SERVICE_TIER=gold` and `REGION_CODE=emea-1`, and run detached container `scoped-runner` using `--env-file` plus `-e SERVICE_PORT=9095`.
