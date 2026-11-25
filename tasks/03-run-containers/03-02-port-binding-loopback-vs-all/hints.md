## Level 1 — Nudge
`-p IP:HOST_PORT:CONTAINER_PORT` restricts host socket binding to `IP`.

## Level 2 — Approach
Run `admin-local` with `-p 127.0.0.1:18081:8080`, run `public-front` with `-p 0.0.0.0:18082:8080` (or `-p 18082:8080`), and redirect `podman port admin-local` to `admin-port.txt`.

## Level 3 — Key Commands
```bash
podman run -d --name admin-local -p 127.0.0.1:18081:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine
podman run -d --name public-front -p 0.0.0.0:18082:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine
podman port admin-local > ~/workspace/03-02/admin-port.txt
```
