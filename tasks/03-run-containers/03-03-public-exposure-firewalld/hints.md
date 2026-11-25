## Level 1 — Nudge
Rootless Podman uses `pasta` user-mode networking and does **not** inject `nftables`/`firewalld` rules automatically — remember `firewall-cmd --permanent --add-port=...` + `--reload`!

## Level 2 — Approach
Start `edge-portal` with `-p 0.0.0.0:8883:8080 -v /home/student/apps/static-portal/public:/usr/share/nginx/html:ro,z`, then open `8883/tcp` permanently in `firewalld` and reload.

## Level 3 — Key Commands
```bash
podman run -d --name edge-portal \
  -p 0.0.0.0:8883:8080 \
  -v /home/student/apps/static-portal/public:/usr/share/nginx/html:ro,z \
  quay.io/nginx/nginx-unprivileged:1.26-alpine
sudo firewall-cmd --permanent --add-port=8883/tcp
sudo firewall-cmd --reload
```
