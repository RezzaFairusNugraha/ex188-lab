## Level 1 — Nudge
Check `man containerfile` for the exact syntax of `FROM`, `RUN`, `COPY`, `EXPOSE`, and JSON-array `CMD`.

## Level 2 — Approach
Write `/home/student/workspace/01-01/Containerfile` starting with `FROM registry.access.redhat.com/ubi10/ubi:latest`, install `httpd` with `dnf install -y httpd && dnf clean all`, copy `index.html`, expose `80`, set `CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]`, and run `podman build -t ...`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/01-01/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y httpd && dnf clean all
COPY index.html /var/www/html/index.html
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EOF
podman build -t localhost/ubi10-httpd:1.0 ~/workspace/01-01
```
