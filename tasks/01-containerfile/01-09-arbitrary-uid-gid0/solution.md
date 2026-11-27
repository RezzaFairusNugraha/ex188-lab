## Solution
```bash
# Note: setup already pre-stages vendor files in the workspace directory
cp -r /home/student/apps/webapp-flask/. /home/student/workspace/01-09/
cat > /home/student/workspace/01-09/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/webapp /var/lib/webapp/data \
    && dnf clean all
WORKDIR /opt/webapp
COPY app.py requirements.txt /opt/webapp/
RUN chown -R 1001:0 /opt/webapp /var/lib/webapp \
    && chmod -R g=u /opt/webapp /var/lib/webapp
ENV APP_PORT=8080 APP_ENV=production CHECK_STORAGE=1
EXPOSE 8080
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF

podman build -t localhost/webapp-ocp-ready:1.0 /home/student/workspace/01-09
```

## Explanation
Because arbitrary UIDs injected at runtime always belong to GID `0`, `chown -R 1001:0` + `chmod -R g=u` grants write access to any injected UID without resorting to insecure world-writable `chmod 777`.

## Common Mistakes
- Using `chmod 775` when owner permissions were `700` — `chmod -R g=u` is safer and cleaner because it copies exact owner `rwx` bits to group `0`.
