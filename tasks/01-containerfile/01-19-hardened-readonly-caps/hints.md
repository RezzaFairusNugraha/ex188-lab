## Level 1 — Nudge
Check `man podman-run` for `--read-only`, `--tmpfs`, `--cap-drop`, and `--security-opt`.

## Level 2 — Approach
Build `localhost/webapp-hardened:1.0` as `USER 1001` (avoid declaring `VOLUME` so no implicit writable volume is needed unless desired), and launch `hardened-web` with `--read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m --cap-drop=ALL --security-opt=no-new-privileges`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/webapp-flask/. ~/workspace/01-19/
cat > ~/workspace/01-19/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp && chown -R 1001:0 /opt/webapp && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
EXPOSE 8080
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -t localhost/webapp-hardened:1.0 ~/workspace/01-19
podman run -d --name hardened-web \
  -p 8099:8080 -e APP_ENV=production \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  localhost/webapp-hardened:1.0
```
