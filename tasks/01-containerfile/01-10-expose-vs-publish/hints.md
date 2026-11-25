## Level 1 — Nudge
Copy the files into your build context first (Podman cannot `COPY` from paths outside the build context!), declare `EXPOSE 8080`, then use `-p` for `portal-explicit` and `-P` + `podman port` for `portal-auto`.

## Level 2 — Approach
1. Copy `~/apps/static-portal/conf/nginx.conf` and `~/apps/static-portal/public` into `~/workspace/01-10/`.
2. Build `localhost/portal-expose:1.0` with `EXPOSE 8080`.
3. Run `podman run -d --name portal-explicit -p 8091:8080 localhost/portal-expose:1.0`.
4. Run `podman run -d --name portal-auto -P localhost/portal-expose:1.0` and capture the port from `podman port portal-auto 8080/tcp`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/static-portal/conf ~/apps/static-portal/public ~/workspace/01-10/
cat > ~/workspace/01-10/Containerfile <<'EOF'
FROM quay.io/nginx/nginx-unprivileged:1.26-alpine
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
EXPOSE 8080
EOF
podman build -t localhost/portal-expose:1.0 ~/workspace/01-10
podman run -d --name portal-explicit -p 8091:8080 localhost/portal-expose:1.0
podman run -d --name portal-auto -P localhost/portal-expose:1.0
podman port portal-auto 8080/tcp | awk -F: '{print $NF}' > ~/workspace/01-10/auto-port.txt
```
