## Level 1 — Nudge
Check `man podman-unshare` and `man podman-run` (search `/keep-id`). `podman unshare chown 1001:1001` executes `chown` *inside* the rootless user namespace!

## Level 2 — Approach
1. Build `localhost/worker-uid1001:1.0` with `USER 1001`.
2. Create `unshare-spool/{inbox,outbox}`, run `podman unshare chown -R 1001:1001 ~/workspace/01-18/unshare-spool`, and start `worker-unshare`.
3. Create `keepid-spool/{inbox,outbox}` as `student`, and start `worker-keepid` with `--userns=keep-id:uid=1001,gid=1001`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/worker-py/. ~/workspace/01-18/build/
cat > ~/workspace/01-18/build/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/worker /var/spool/worker/inbox /var/spool/worker/outbox && chown -R 1001:1001 /opt/worker /var/spool/worker && dnf clean all
COPY --chown=1001:1001 worker.py healthcheck.py /opt/worker/
USER 1001
CMD ["python3", "/opt/worker/worker.py", "--interval", "1"]
EOF
podman build -t localhost/worker-uid1001:1.0 ~/workspace/01-18/build

mkdir -p ~/workspace/01-18/unshare-spool/{inbox,outbox}
podman unshare chown -R 1001:1001 ~/workspace/01-18/unshare-spool
podman run -d --name worker-unshare \
  -v ~/workspace/01-18/unshare-spool/inbox:/var/spool/worker/inbox:Z \
  -v ~/workspace/01-18/unshare-spool/outbox:/var/spool/worker/outbox:Z \
  localhost/worker-uid1001:1.0

mkdir -p ~/workspace/01-18/keepid-spool/{inbox,outbox}
podman run -d --name worker-keepid --userns=keep-id:uid=1001,gid=1001 \
  -v ~/workspace/01-18/keepid-spool/inbox:/var/spool/worker/inbox:Z \
  -v ~/workspace/01-18/keepid-spool/outbox:/var/spool/worker/outbox:Z \
  localhost/worker-uid1001:1.0
```
