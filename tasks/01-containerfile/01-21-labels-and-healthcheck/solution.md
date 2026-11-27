## Solution
```bash
# Note: setup already pre-stages vendor files in the workspace directory
cp -r /home/student/apps/worker-py/. /home/student/workspace/01-21/
cat > /home/student/workspace/01-21/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
LABEL org.opencontainers.image.title="spool-worker" \
      org.opencontainers.image.vendor="Acme Platform" \
      com.example.team="cloud-ops"
RUN dnf install -y python3 \
    && mkdir -p /opt/worker /var/spool/worker/inbox /var/spool/worker/outbox \
    && chown -R 1001:0 /opt/worker /var/spool/worker \
    && chmod -R g=u /var/spool/worker \
    && dnf clean all
COPY --chown=1001:0 worker.py healthcheck.py /opt/worker/
USER 1001
HEALTHCHECK --interval=10s --timeout=3s --retries=2 \
  CMD ["python3", "/opt/worker/healthcheck.py"]
CMD ["python3", "/opt/worker/worker.py", "--interval", "2"]
EOF

podman build --format docker -t localhost/worker-labeled:1.0 /home/student/workspace/01-21
podman run -d --name worker-hc localhost/worker-labeled:1.0
sleep 2
podman healthcheck run worker-hc
```

## Explanation
In Podman v5, standard OCI v1 image manifests do not have a `Healthcheck` field — Podman prints `STEP ... HEALTHCHECK is not supported for OCI image format and will be ignored` unless you pass `podman build --format docker`! Remembering `--format docker` for `HEALTHCHECK` in `Containerfile` is essential on the exam.

## Common Mistakes
- Building without `--format docker` and wondering why `podman inspect` shows no healthcheck!
