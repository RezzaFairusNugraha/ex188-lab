## Level 1 — Nudge
Any `ARG` placed above `FROM` is cleared at `FROM`. Write a bare `ARG UBI_VARIANT` after `FROM` (with no `=` needed) to bring the pre-`FROM` value back into scope!

## Level 2 — Approach
1. Put `ARG UBI_VARIANT=ubi-minimal`, then `FROM registry.access.redhat.com/ubi10/${UBI_VARIANT}:latest`, then `ARG UBI_VARIANT`, then `RUN printf '%s\n' "${UBI_VARIANT}" > /etc/selected-variant`.
2. Build `localhost/scoped-ubi:1.0`.
3. Write `runtime.env` (`SERVICE_TIER=gold`, `REGION_CODE=emea-1`) and launch `scoped-runner` with `--env-file` and `-e SERVICE_PORT=9095`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/01-12/Containerfile <<'EOF'
ARG UBI_VARIANT=ubi-minimal
FROM registry.access.redhat.com/ubi10/${UBI_VARIANT}:latest
ARG UBI_VARIANT
RUN printf '%s\n' "${UBI_VARIANT}" > /etc/selected-variant
ENV SERVICE_TIER=standard SERVICE_PORT=8080
USER 1001
CMD ["sh", "-c", "sleep 3600"]
EOF
podman build --build-arg UBI_VARIANT=ubi-minimal -t localhost/scoped-ubi:1.0 ~/workspace/01-12
printf 'SERVICE_TIER=gold\nREGION_CODE=emea-1\n' > ~/workspace/01-12/runtime.env
podman run -d --name scoped-runner --env-file ~/workspace/01-12/runtime.env -e SERVICE_PORT=9095 localhost/scoped-ubi:1.0
```
