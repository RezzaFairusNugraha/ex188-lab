## Solution
```bash
# Note: setup already pre-stages vendor files in the workspace directory
cp -r /home/student/apps/api-express/. /home/student/workspace/01-17/build/
cat > /home/student/workspace/01-17/build/Containerfile <<'EOF'
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
CMD ["node", "/opt/api-express/server.js"]
EOF

podman build -t localhost/api-express:1.0 /home/student/workspace/01-17/build
printf '[{"sku":"A1","name":"Item1","stock":5},{"sku":"B2","name":"Item2","stock":9}]\n' > /home/student/workspace/01-17/custom-catalog.json
podman volume create api-audit-vol
podman run -d --name inventory-api -p 3017:3000 \
  -v /home/student/workspace/01-17/custom-catalog.json:/etc/api-express/catalog.json:ro,z \
  -v api-audit-vol:/var/lib/api-express/audit \
  localhost/api-express:1.0
sleep 2
curl -fsS -X POST http://127.0.0.1:3017/api/v1/audit -d 'init-check'
```

## Explanation
When Podman mounts a brand-new **empty** named volume onto an existing directory inside an image (`/var/lib/api-express/audit`), Podman copies the directory's ownership (`1001:0`) from the image into the named volume! If that path was never created in the `Containerfile`, the volume defaults to `root:root` (`0755`) and non-root `USER 1001` gets `EACCES`.

## Common Mistakes
- Not creating `/var/lib/api-express/audit` owned by `1001` in the `Containerfile`, leaving the named volume owned by `0:0`.
