## Solution
```bash
cp -r /home/student/apps/webapp-flask/. /home/student/workspace/01-16/
mkdir -p /home/student/workspace/01-16/host-notes

cat > /home/student/workspace/01-16/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/webapp /var/lib/webapp/data \
    && chown -R 1001:0 /opt/webapp /var/lib/webapp \
    && chmod -R g=u /opt/webapp /var/lib/webapp \
    && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
VOLUME ["/var/lib/webapp/data"]
USER 1001
EXPOSE 8080
CMD ["python3", "/opt/webapp/app.py"]
EOF

podman build -t localhost/webapp-vol:1.0 /home/student/workspace/01-16
podman run -d --name notes-writer --userns=--userns=keep-id:uid=1001,gid=1001:uid=1001,gid=1001:uid=1001,gid=1001 \
  -p 8096:8080 -e APP_ENV=production \
  -v /home/student/workspace/01-16/host-notes:/var/lib/webapp/data:Z \
  localhost/webapp-vol:1.0
sleep 2
curl -fsS -X POST 'http://127.0.0.1:8096/entries?msg=first-persistent-note'
```

## Explanation
Important `Containerfile` gotcha: any `RUN` modifications to `/var/lib/webapp/data` placed **after** `VOLUME ["/var/lib/webapp/data"]` are discarded! Always place `mkdir`/`chown` *before* `VOLUME`.

## Common Mistakes
- Omitting `:Z` on SELinux-enforcing RHEL 10, causing `PermissionError: [Errno 13] Permission denied` on `POST /entries`.
