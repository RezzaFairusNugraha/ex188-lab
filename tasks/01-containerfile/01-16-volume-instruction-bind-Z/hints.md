## Level 1 — Nudge
Include `VOLUME ["/var/lib/webapp/data"]` in `Containerfile`, pass `-v .../host-notes:/var/lib/webapp/data:Z` (with `--userns=--userns=keep-id:uid=1001,gid=1001:uid=1001,gid=1001` if running as UID 1001), and trigger `POST /entries`.

## Level 2 — Approach
Build `localhost/webapp-vol:1.0` with `USER 1001` and `VOLUME ["/var/lib/webapp/data"]`. Create `~/workspace/01-16/host-notes`, start `notes-writer` with `--userns=--userns=keep-id:uid=1001,gid=1001:uid=1001,gid=1001:uid=1001,gid=1001 -v ~/workspace/01-16/host-notes:/var/lib/webapp/data:Z -p 8096:8080 -e APP_ENV=production`, and run `curl -X POST 'http://127.0.0.1:8096/entries?msg=first-persistent-note'`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/webapp-flask/. ~/workspace/01-16/
mkdir -p ~/workspace/01-16/host-notes
cat > ~/workspace/01-16/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp /var/lib/webapp/data && chown -R 1001:0 /opt/webapp /var/lib/webapp && chmod -R g=u /var/lib/webapp && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
VOLUME ["/var/lib/webapp/data"]
USER 1001
EXPOSE 8080
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -t localhost/webapp-vol:1.0 ~/workspace/01-16
podman run -d --name notes-writer --userns=--userns=keep-id:uid=1001,gid=1001:uid=1001,gid=1001:uid=1001,gid=1001 \
  -p 8096:8080 -e APP_ENV=production \
  -v ~/workspace/01-16/host-notes:/var/lib/webapp/data:Z \
  localhost/webapp-vol:1.0
sleep 2
curl -fsS -X POST 'http://127.0.0.1:8096/entries?msg=first-persistent-note'
```
