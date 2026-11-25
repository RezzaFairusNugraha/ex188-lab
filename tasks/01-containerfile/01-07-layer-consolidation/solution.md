## Solution
```bash
cat > /home/student/workspace/01-07/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && printf 'ex188-seed' | sha256sum | awk '{print $1}' > /etc/app-checksum \
    && dnf clean all \
    && rm -rf /var/cache/dnf /tmp/stage.bin
USER 1001
CMD ["python3", "--version"]
EOF

podman build -t localhost/lean-python:1.0 /home/student/workspace/01-07
```

## Explanation
OverlayFS commits the filesystem diff only at the *end* of each `RUN` instruction. Any temporary tarball, RPM cache, or staging file created and deleted inside the same `RUN` instruction adds zero bytes to the layer!

## Common Mistakes
- Leaving `RUN dnf clean all` as a separate instruction at the bottom of the `Containerfile`.
