## Solution
```bash
cp -r /home/student/apps/worker-py/. /home/student/workspace/01-14/
cat > /home/student/workspace/01-14/Containerfile <<'EOF'
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

podman build -t localhost/worker-appliance:1.0 /home/student/workspace/01-14
podman run -d --name worker-default localhost/worker-appliance:1.0
podman run -d --name worker-fast localhost/worker-appliance:1.0 --interval 1 --prefix FAST
```

## Explanation
If `ENTRYPOINT` were written in shell form (`ENTRYPOINT python3 ...`), Podman would **ignore** `CMD` and any trailing `podman run` arguments! Both instructions must use JSON exec form to compose properly.

## Common Mistakes
- Writing shell-form `ENTRYPOINT`, which silently discards `CMD` arguments!
