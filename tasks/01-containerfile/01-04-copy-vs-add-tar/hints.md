## Level 1 — Nudge
`ADD` automatically extracts recognized local compressed tar archives into a destination directory, whereas `COPY` always copies archives byte-for-byte without extraction.

## Level 2 — Approach
Use `ADD site-assets.tar.gz /usr/share/nginx/html/` for the extracted web root, and `COPY release-backup.tar.gz /usr/share/nginx/html/downloads/release-backup.tar.gz` for the literal file.

## Level 3 — Key Commands
```bash
cat > ~/workspace/01-04/Containerfile <<'EOF'
FROM quay.io/nginx/nginx-unprivileged:1.26-alpine
ADD site-assets.tar.gz /usr/share/nginx/html/
COPY release-backup.tar.gz /usr/share/nginx/html/downloads/release-backup.tar.gz
EOF
podman build -t localhost/portal-static:1.0 ~/workspace/01-04
```
