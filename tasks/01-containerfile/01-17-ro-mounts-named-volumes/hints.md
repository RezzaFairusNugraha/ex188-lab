## Level 1 — Nudge
Pre-create `/var/lib/api-express/audit` owned by `1001` inside the image so Podman copies those permissions onto the empty `api-audit-vol` named volume when first mounted!

## Level 2 — Approach
1. Build `localhost/api-express:1.0` ensuring `/var/lib/api-express/audit` is owned by `1001:0` before `USER 1001`.
2. Write `custom-catalog.json` and run `podman volume create api-audit-vol`.
3. Launch `inventory-api` with `-v .../custom-catalog.json:/etc/api-express/catalog.json:ro,z -v api-audit-vol:/var/lib/api-express/audit`, then `curl -X POST http://127.0.0.1:3017/api/v1/audit`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/api-express/. ~/workspace/01-17/build/
cat > ~/workspace/01-17/build/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y nodejs && mkdir -p /opt/api-express /var/lib/api-express/audit && chown -R 1001:0 /opt/api-express /var/lib/api-express && chmod -R g=u /var/lib/api-express && dnf clean all
WORKDIR /opt/api-express
COPY --chown=1001:0 package.json server.js /opt/api-express/
COPY --chown=1001:0 config /opt/api-express/config
USER 1001
EXPOSE 3000
CMD ["node", "/opt/api-express/server.js"]
EOF
podman build -t localhost/api-express:1.0 ~/workspace/01-17/build
printf '[{"sku":"A1","name":"Item1","stock":5},{"sku":"B2","name":"Item2","stock":9}]\n' > ~/workspace/01-17/custom-catalog.json
podman volume create api-audit-vol
podman run -d --name inventory-api -p 3017:3000 \
  -v ~/workspace/01-17/custom-catalog.json:/etc/api-express/catalog.json:ro,z \
  -v api-audit-vol:/var/lib/api-express/audit \
  localhost/api-express:1.0
sleep 2
curl -fsS -X POST http://127.0.0.1:3017/api/v1/audit -d 'init-check'
```
