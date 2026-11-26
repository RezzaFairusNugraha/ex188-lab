## Level 1 — Nudge
Red Hat's arbitrary-UID pattern sets directory group ownership to GID `0` (`chgrp -R 0`) and mirrors user permissions onto group permissions (`chmod -R g=u`).

## Level 2 — Approach
Create `/opt/webapp` and `/var/lib/webapp/data`, copy `app.py`, run `chgrp -R 0 /opt/webapp /var/lib/webapp && chmod -R g=u /opt/webapp /var/lib/webapp`, set `USER 1001`, build, and test with `podman run --rm --user 42420:0 ...`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/webapp-flask/. ~/workspace/01-09/
cat > ~/workspace/01-09/Containerfile <<'EOF'
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
podman build -t localhost/webapp-ocp-ready:1.0 ~/workspace/01-09
```
