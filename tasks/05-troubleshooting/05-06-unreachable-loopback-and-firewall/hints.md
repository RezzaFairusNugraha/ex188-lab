## Level 1 — Nudge
Check `podman logs webapp-ext-0506` (`127.0.0.1:8080` inside container!), `podman port webapp-ext-0506` (`127.0.0.1:8506` on host!), and `sudo firewall-cmd --list-ports`!

## Level 2 — Approach
Recreate `webapp-ext-0506` setting `-p 0.0.0.0:8506:8080` and `-e APP_BIND=0.0.0.0 -e APP_ENV=production`, then permanently add `8506/tcp` to `firewalld` and reload.

## Level 3 — Key Commands
```bash
podman rm -f webapp-ext-0506
podman run -d --name webapp-ext-0506 -p 0.0.0.0:8506:8080 \
  -e APP_ENV=production -e APP_BIND=0.0.0.0 \
  localhost/ts-web-0506:1.0
sudo firewall-cmd --permanent --add-port=8506/tcp
sudo firewall-cmd --reload
```
