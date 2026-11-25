## Level 1 — Nudge
When both `ENTRYPOINT` and `CMD` use JSON exec arrays, Podman appends `CMD` elements as default arguments to `ENTRYPOINT`, and any trailing args on `podman run <image> <args>` replace `CMD` only.

## Level 2 — Approach
Package `worker-py` with `ENTRYPOINT ["python3", "/opt/worker/worker.py"]` and `CMD ["--interval", "5", "--prefix", "DEFAULT"]`. Start `worker-default` with no trailing args and `worker-fast` with trailing `--interval 1 --prefix FAST`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/worker-py/. ~/workspace/01-14/
cat > ~/workspace/01-14/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/worker /var/spool/worker/inbox /var/spool/worker/outbox \
    && chown -R 1001:1001 /opt/worker /var/spool/worker \
    && dnf clean all
COPY --chown=1001:1001 worker.py healthcheck.py /opt/worker/
USER 1001
ENTRYPOINT ["python3", "/opt/worker/worker.py"]
CMD ["--interval", "5", "--prefix", "DEFAULT"]
EOF
podman build -t localhost/worker-appliance:1.0 ~/workspace/01-14
podman run -d --name worker-default localhost/worker-appliance:1.0
podman run -d --name worker-fast localhost/worker-appliance:1.0 --interval 1 --prefix FAST
```
