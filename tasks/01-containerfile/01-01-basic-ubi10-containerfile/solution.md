## Solution
```bash
cat > /home/student/workspace/01-01/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y httpd && dnf clean all
COPY index.html /var/www/html/index.html
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EOF

podman build -t localhost/ubi10-httpd:1.0 /home/student/workspace/01-01
```

## Explanation
`podman build` automatically looks for `Containerfile` first in the build context directory. Using exec-form `CMD` runs `httpd` directly as PID 1 inside the container without wrapping `/bin/sh -c`.

## Common Mistakes
- Naming the file `Dockerfile` when exam instructions explicitly require `Containerfile`.
- Running `systemctl start httpd` in `CMD` (standard UBI10 does not run systemd PID 1; run `httpd -D FOREGROUND` directly).
