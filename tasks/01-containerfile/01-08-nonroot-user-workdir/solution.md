## Solution
```bash
cp -r /home/student/apps/webapp-flask/. /home/student/workspace/01-08/
cat > /home/student/workspace/01-08/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/webapp /var/lib/webapp/data \
    && chown -R 1001:1001 /opt/webapp /var/lib/webapp \
    && dnf clean all
WORKDIR /opt/webapp
COPY --chown=1001:1001 app.py requirements.txt /opt/webapp/
ENV APP_PORT=8080 APP_ENV=production
EXPOSE 8080
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF

podman build -t localhost/webapp-flask:1.0 /home/student/workspace/01-08
```

## Explanation
Numeric `USER 1001` (rather than a named user like `USER appuser`) allows runtime verification of non-root identity without needing an `/etc/passwd` lookup before container creation.

## Common Mistakes
- Putting `USER 1001` *before* `RUN dnf install`, causing `dnf` to fail with `Error: This command has to be run with superuser privileges`.
