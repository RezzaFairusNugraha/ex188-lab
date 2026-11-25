## Level 1 — Nudge
Files created in `RUN` step A and deleted in `RUN` step B still occupy full space in layer A. Chain creation, use, and deletion inside one `RUN` instruction with `&&`.

## Level 2 — Approach
Combine `dnf install -y python3`, any staging file creation/checksum write, `rm -f /tmp/stage.bin`, and `dnf clean all && rm -rf /var/cache/dnf` into a single `RUN` block using `\` line continuations, then build `localhost/lean-python:1.0`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/01-07/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && dd if=/dev/zero of=/tmp/stage.bin bs=1M count=50 \
    && printf 'ex188-seed' | sha256sum | awk '{print $1}' > /etc/app-checksum \
    && rm -f /tmp/stage.bin \
    && dnf clean all \
    && rm -rf /var/cache/dnf
USER 1001
CMD ["python3", "--version"]
EOF
podman build -t localhost/lean-python:1.0 ~/workspace/01-07
```
