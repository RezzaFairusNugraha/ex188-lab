## Solution
```bash
cat > /home/student/workspace/01-11/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
ARG BUILD_CHANNEL=dev
ARG APP_RELEASE=1.0.0
RUN printf '%s\n' "${BUILD_CHANNEL}" > /etc/build-channel
ENV APP_RELEASE=${APP_RELEASE} \
    LOG_FORMAT=json
USER 1001
EOF

podman build -t localhost/release-demo:default /home/student/workspace/01-11
podman build \
  --build-arg BUILD_CHANNEL=production \
  --build-arg APP_RELEASE=2.4.0 \
  -t localhost/release-demo:prod /home/student/workspace/01-11
```

## Explanation
`ARG` values are available to `RUN` commands at build time, disappear when the image finishes building, and never pollute `podman run ... env` unless assigned to `ENV`. Note however that `ARG` values *are* still visible in `podman history`, so never pass real secrets via `ARG`!

## Common Mistakes
- Declaring `ARG` *before* `FROM` and forgetting that `FROM` resets `ARG` scope unless re-declared after `FROM`!
