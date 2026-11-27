## Solution
```bash
# Note: setup already pre-stages vendor files in the workspace directory
cp -r /home/student/apps/webapp-flask/. /home/student/workspace/01-19/
cat > /home/student/workspace/01-19/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/webapp \
    && chown -R 1001:0 /opt/webapp \
    && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
EXPOSE 8080
CMD ["python3", "/opt/webapp/app.py"]
EOF

podman build -t localhost/webapp-hardened:1.0 /home/student/workspace/01-19
podman run -d --name hardened-web \
  -p 8099:8080 \
  -e APP_ENV=production \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  localhost/webapp-hardened:1.0
```

## Explanation
Because `webapp-flask` binds port `8080` (`>= 1024`), it needs not even `CAP_NET_BIND_SERVICE` — `--cap-drop=ALL` works cleanly! Meanwhile `--security-opt=no-new-privileges` prevents `setuid`/`setgid` binaries from escalating privileges.

## Common Mistakes
- Trying to bind container port `80` while passing `--cap-drop=ALL` (fails with `Permission denied` because `CAP_NET_BIND_SERVICE` was dropped).
