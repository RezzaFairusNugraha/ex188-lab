## Solution
```bash
# Note: setup already pre-stages vendor files in the workspace directory
cp -r /home/student/apps/api-express/. /home/student/workspace/01-23/
cat > /home/student/workspace/01-23/Containerfile <<'EOF'
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

podman build -t localhost/northwind-api:1.2 /home/student/workspace/01-23
podman run -d --name northwind-prod -p 3023:3000 \
  -e AUTH_REQUIRED=true \
  -e API_TOKEN=nw-prod-9912 \
  localhost/northwind-api:1.2
```

## Explanation
Notice the grading script hashes `/opt/api-express/server.js` against the original vendor file! On the real EX188 exam, modifying pre-written application code instead of supplying required environment variables/directories causes automatic check failure.

## Common Mistakes
- Forgetting to copy the `config/` directory (`config/catalog.json`), causing `/api/v1/items` to return an empty list `[]`.
