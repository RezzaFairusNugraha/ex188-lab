## Level 1 — Nudge
Remember `ubi10-minimal` does **not** include `dnf` — use `microdnf` and chain installation + cleanup with `&&` inside one `RUN` line.

## Level 2 — Approach
Start from `registry.access.redhat.com/ubi10/ubi-minimal:latest`, run `microdnf install -y --nodocs tar gzip && microdnf clean all`, set `USER 1001`, set `CMD ["/usr/bin/tar", "--version"]`, and build `localhost/minimal-archiver:1.0`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/01-03/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN microdnf install -y --nodocs tar gzip && microdnf clean all
USER 1001
CMD ["/usr/bin/tar", "--version"]
EOF
podman build -t localhost/minimal-archiver:1.0 ~/workspace/01-03
```
