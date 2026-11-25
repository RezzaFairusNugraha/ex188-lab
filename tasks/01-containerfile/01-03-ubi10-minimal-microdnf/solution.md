## Solution
```bash
cat > /home/student/workspace/01-03/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN microdnf install -y --nodocs tar gzip && microdnf clean all
USER 1001
CMD ["/usr/bin/tar", "--version"]
EOF

podman build -t localhost/minimal-archiver:1.0 /home/student/workspace/01-03
```

## Explanation
If `microdnf clean all` is placed in a *second* `RUN` instruction, the cached RPM metadata is already frozen into the previous immutable OCI layer and image size does not shrink!

## Common Mistakes
- Calling `dnf` inside `ubi10/ubi-minimal` (`dnf: command not found`).
- Putting `RUN microdnf clean all` on a separate line from `RUN microdnf install`.
