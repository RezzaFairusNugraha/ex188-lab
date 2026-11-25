## Level 1 — Nudge
Read `~/apps/webapp-flask/README.md` first. Make sure `/var/lib/webapp/data` is created and `chown`ed before switching `USER 1001`.

## Level 2 — Approach
Copy `~/apps/webapp-flask/*` to `~/workspace/01-08/`, install `python3` in `RUN` along with `mkdir -p /var/lib/webapp/data && chown -R 1001:1001 /var/lib/webapp`, set `WORKDIR /opt/webapp`, `COPY` the app, set `ENV`, `EXPOSE`, `USER 1001`, and `CMD`, then `podman build`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/webapp-flask/. ~/workspace/01-08/
cat > ~/workspace/01-08/Containerfile <<'EOF'
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
podman build -t localhost/webapp-flask:1.0 ~/workspace/01-08
```
