# Task 01-25: Fixing a Broken Multi-Stage Containerfile with Leaked Credentials and Root Trap

## Objective
`/home/student/workspace/01-25/Containerfile` attempts to build `metrics-go` in two stages, but fails to build and violates security policy:
1. Stage 1 copies `.` including `scrape-token.secret` and copies `/src` wholesale into Stage 2 (`COPY --from=buildstage /src /app`), leaking both source code and `scrape-token.secret`!
2. Stage 1 compiles to `/tmp/metrics` while Stage 2 tries to execute `/usr/local/bin/metrics-agent`.
3. Stage 2 runs as `root` and uses shell-form `ENTRYPOINT /usr/local/bin/metrics-agent`.

## Specification
1. Create `.containerignore` in `/home/student/workspace/01-25/` excluding `*.secret` (preserve `scrape-token.secret` on the host!).
2. Fix `/home/student/workspace/01-25/Containerfile` so:
   - Stage 1 builds static binary `/out/metrics-agent` (`CGO_ENABLED=0`).
   - Stage 2 (`registry.access.redhat.com/ubi10/ubi-minimal:latest`) copies **only** `/out/metrics-agent` to `/usr/local/bin/metrics-agent` (`0755`), runs as `USER 1001`, exposes `9090`, and uses exec-form `ENTRYPOINT ["/usr/local/bin/metrics-agent"]`.
3. Build `localhost/metrics-secure:2.0`.
4. Create Podman secret `metrics_scrape_tok` from `/home/student/workspace/01-25/scrape-token.secret` and run detached container `metrics-prod` on `-p 9125:9090 --secret metrics_scrape_tok,target=/run/secrets/scrape_token`.
