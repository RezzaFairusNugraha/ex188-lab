## Solution
```bash
cat > /home/student/workspace/01-04/Containerfile <<'EOF'
FROM quay.io/nginx/nginx-unprivileged:1.26-alpine
ADD site-assets.tar.gz /usr/share/nginx/html/
COPY release-backup.tar.gz /usr/share/nginx/html/downloads/release-backup.tar.gz
EOF

podman build -t localhost/portal-static:1.0 /home/student/workspace/01-04
```

## Explanation
Per OCI/`Containerfile` rules, `ADD` unpacks local `.tar`, `.tar.gz`, `.tgz`, `.tar.bz2`, and `.tar.xz` archives into the destination directory, while `COPY` never unpacks archives. Prefer `COPY` by default unless local tarball auto-extraction is specifically desired.

## Common Mistakes
- Using `ADD` for `release-backup.tar.gz`, which turns `/usr/share/nginx/html/downloads/release-backup.tar.gz` into a directory containing `data.txt`!
