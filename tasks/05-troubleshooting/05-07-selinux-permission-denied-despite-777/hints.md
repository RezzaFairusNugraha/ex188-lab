## Level 1 — Nudge
Run `ls -dZ ~/workspace/05-07/data` — `user_home_t` blocks `container_t` regardless of `chmod 0777`! Fix both mode (`0755` + `keep-id`) and SELinux (`:Z`).

## Level 2 — Approach
Run `chmod 0755 ~/workspace/05-07/data`, remove `selinux-victim`, and recreate it with `--userns=keep-id:uid=1001,gid=1001` and `-v ~/workspace/05-07/data:/var/lib/webapp/data:Z`.

## Level 3 — Key Commands
```bash
chmod 0755 ~/workspace/05-07/data
podman rm -f selinux-victim
podman run -d --name selinux-victim -p 8507:8080 \
  --userns=keep-id:uid=1001,gid=1001 \
  -e APP_ENV=production -e CHECK_STORAGE=1 \
  -v ~/workspace/05-07/data:/var/lib/webapp/data:Z \
  localhost/ts-web-0507:1.0
```
