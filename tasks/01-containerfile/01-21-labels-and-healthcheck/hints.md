## Level 1 — Nudge
CRITICAL Podman detail: `podman build` defaults to `--format oci`, which strips `HEALTHCHECK` unless `--format docker` is passed at build time!

## Level 2 — Approach
Write `LABEL` and `HEALTHCHECK` instructions in `Containerfile`, build with `podman build --format docker -t localhost/worker-labeled:1.0`, start `worker-hc`, and trigger `podman healthcheck run worker-hc`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/worker-py/. ~/workspace/01-21/
cat > ~/workspace/01-21/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
LABEL org.opencontainers.image.title="spool-worker" \
      org.opencontainers.image.vendor="Acme Platform" \
      com.example.team="cloud-ops"
RUN dnf install -y python3 && mkdir -p /opt/worker /var/spool/worker/inbox /var/spool/worker/outbox && chown -R 1001:0 /opt/worker /var/spool/worker && chmod -R g=u /var/spool/worker && dnf clean all
COPY --chown=1001:0 worker.py healthcheck.py /opt/worker/
USER 1001
HEALTHCHECK --interval=10s --timeout=3s --retries=2 CMD ["python3", "/opt/worker/healthcheck.py"]
CMD ["python3", "/opt/worker/worker.py", "--interval", "2"]
EOF
podman build --format docker -t localhost/worker-labeled:1.0 ~/workspace/01-21
podman run -d --name worker-hc localhost/worker-labeled:1.0
sleep 2 && podman healthcheck run worker-hc
```
