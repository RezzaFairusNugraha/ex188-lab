## Solution
```bash
cp -r /home/student/apps/worker-py/. /home/student/workspace/01-18/build/
cat > /home/student/workspace/01-18/build/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/worker /var/spool/worker/inbox /var/spool/worker/outbox \
    && chown -R 1001:1001 /opt/worker /var/spool/worker \
    && dnf clean all
COPY --chown=1001:1001 worker.py healthcheck.py /opt/worker/
USER 1001
CMD ["python3", "/opt/worker/worker.py", "--interval", "1"]
EOF

podman build -t localhost/worker-uid1001:1.0 /home/student/workspace/01-18/build

mkdir -p /home/student/workspace/01-18/unshare-spool/{inbox,outbox}
podman unshare chown -R 1001:1001 /home/student/workspace/01-18/unshare-spool
podman run -d --name worker-unshare \
  -v /home/student/workspace/01-18/unshare-spool/inbox:/var/spool/worker/inbox:Z \
  -v /home/student/workspace/01-18/unshare-spool/outbox:/var/spool/worker/outbox:Z \
  localhost/worker-uid1001:1.0

mkdir -p /home/student/workspace/01-18/keepid-spool/{inbox,outbox}
podman run -d --name worker-keepid --userns=keep-id:uid=1001,gid=1001 \
  -v /home/student/workspace/01-18/keepid-spool/inbox:/var/spool/worker/inbox:Z \
  -v /home/student/workspace/01-18/keepid-spool/outbox:/var/spool/worker/outbox:Z \
  localhost/worker-uid1001:1.0
```

## Explanation
Rootless UID mismatch is one of the top exam failure points!
- `--userns=keep-id:uid=1001,gid=1001` (Podman v4.3+/v5) maps the host user (`student`) directly onto UID `1001` inside the container, so files remain owned by `student` on the host!
- `podman unshare chown 1001:1001` shifts host directory ownership to subordinate UID `101000` (note: to remove `unshare`-owned files later as `student`, use `podman unshare rm -rf`).

## Common Mistakes
- Passing plain `--userns=keep-id` when the image specifies `USER 1001` while `student` has host UID `1000` (`1000 != 1001` still causes permission denied unless `uid=1001,gid=1001` or `--user 1000` is used!).
