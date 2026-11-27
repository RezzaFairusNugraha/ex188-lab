## Solution
```bash
# Note: setup already pre-stages vendor files in the workspace directory
cp -r /home/student/apps/static-portal/conf /home/student/apps/static-portal/public /home/student/workspace/01-10/
cat > /home/student/workspace/01-10/Containerfile <<'EOF'
FROM quay.io/nginx/nginx-unprivileged:1.26-alpine
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
EXPOSE 8080
EOF

podman build -t localhost/portal-expose:1.0 /home/student/workspace/01-10
podman run -d --name portal-explicit -p 8091:8080 localhost/portal-expose:1.0
podman run -d --name portal-auto -P localhost/portal-expose:1.0
podman port portal-auto 8080/tcp | head -n1 | awk -F: '{print $NF}' > /home/student/workspace/01-10/auto-port.txt
```

## Explanation
`EXPOSE` only writes `Config.ExposedPorts` metadata into the OCI image JSON. Without `-p` or `-P` at runtime, no host port is bound. Conversely, `-P` ONLY publishes ports listed in `Config.ExposedPorts`.

## Common Mistakes
- Trying `COPY /home/student/apps/...` directly in `Containerfile` without copying into the build context directory first (fails with `path outside of build context`).
