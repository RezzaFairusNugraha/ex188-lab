## Level 1 — Nudge
Read `/home/student/apps/api-express/README.md` carefully: check the required `WORKDIR`, `AUDIT_DIR`, `USER`, `CMD`, and `AUTH_REQUIRED` + token variables!

## Level 2 — Approach
Copy `~/apps/api-express/.` to `~/workspace/01-23/`, install `nodejs`, create `/var/lib/api-express/audit` writable by `1001:0`, copy `package.json`, `server.js`, and `config/` to `/opt/api-express/`, set `USER 1001`, build `localhost/northwind-api:1.2`, and run `northwind-prod` with `-p 3023:3000 -e AUTH_REQUIRED=true -e API_TOKEN=nw-prod-9912`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/api-express/. ~/workspace/01-23/
cat > ~/workspace/01-23/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y nodejs \
    && mkdir -p /opt/api-express /var/lib/api-express/audit \
    && chown -R 1001:0 /opt/api-express /var/lib/api-express \
    && chmod -R g=u /var/lib/api-express \
    && dnf clean all
WORKDIR /opt/api-express
COPY --chown=1001:0 package.json server.js /opt/api-express/
COPY --chown=1001:0 config /opt/api-express/config
USER 1001
EXPOSE 3000
CMD ["node", "server.js"]
EOF
podman build -t localhost/northwind-api:1.2 ~/workspace/01-23
podman run -d --name northwind-prod -p 3023:3000 \
  -e AUTH_REQUIRED=true -e API_TOKEN=nw-prod-9912 \
  localhost/northwind-api:1.2
```
