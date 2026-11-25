## Solution
```bash
cat > /home/student/workspace/01-12/Containerfile <<'EOF'
ARG UBI_VARIANT=ubi-minimal
FROM registry.access.redhat.com/ubi10/${UBI_VARIANT}:latest
ARG UBI_VARIANT
RUN printf '%s\n' "${UBI_VARIANT}" > /etc/selected-variant
ENV SERVICE_TIER=standard SERVICE_PORT=8080
USER 1001
CMD ["sh", "-c", "sleep 3600"]
EOF

podman build --build-arg UBI_VARIANT=ubi-minimal -t localhost/scoped-ubi:1.0 /home/student/workspace/01-12

cat > /home/student/workspace/01-12/runtime.env <<'EOF'
SERVICE_TIER=gold
REGION_CODE=emea-1
EOF

podman run -d --name scoped-runner \
  --env-file /home/student/workspace/01-12/runtime.env \
  -e SERVICE_PORT=9095 \
  localhost/scoped-ubi:1.0
```

## Explanation
`ARG` scope resets at every `FROM` boundary (including multi-stage builds). Writing `ARG UBI_VARIANT` without a new default after `FROM` inherits the value passed before `FROM`. Also note precedence: `-e` overrides `--env-file`, which overrides `Containerfile` `ENV`.

## Common Mistakes
- Forgetting `ARG UBI_VARIANT` after `FROM`, resulting in an empty `/etc/selected-variant` file!
