## Level 1 — Nudge
`ARG` exists only during `podman build` unless explicitly promoted into an `ENV` instruction.

## Level 2 — Approach
Define both `ARG`s after `FROM`, write `BUILD_CHANNEL` to `/etc/build-channel` in `RUN`, promote only `APP_RELEASE` into `ENV APP_RELEASE=${APP_RELEASE}`, then run `podman build` once with no `--build-arg` and once with `--build-arg` flags.

## Level 3 — Key Commands
```bash
cat > ~/workspace/01-11/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
ARG BUILD_CHANNEL=dev
ARG APP_RELEASE=1.0.0
RUN printf '%s\n' "${BUILD_CHANNEL}" > /etc/build-channel
ENV APP_RELEASE=${APP_RELEASE} \
    LOG_FORMAT=json
USER 1001
EOF
podman build -t localhost/release-demo:default ~/workspace/01-11
podman build --build-arg BUILD_CHANNEL=production --build-arg APP_RELEASE=2.4.0 \
  -t localhost/release-demo:prod ~/workspace/01-11
```
